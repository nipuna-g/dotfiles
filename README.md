# dotfiles

One flake for two machines, sharing a single home-manager configuration:

| Host | Output | Rebuild with |
| --- | --- | --- |
| NixOS desktop (`x86_64-linux`, KDE Plasma 6) | `nixosConfigurations.nixos` | `sudo nixos-rebuild switch --flake ~/dotfiles#nixos` |
| macOS laptop (`aarch64-darwin`, nix-darwin) | `darwinConfigurations.mac` | `sudo darwin-rebuild switch --flake path:$HOME/dotfiles#mac` |

The `rebuild` alias runs the right one for the host you are on, and `update`
bumps `flake.lock` first. home-manager is a module of each host config rather
than a standalone profile, so there is no `homeConfigurations` output to switch
on its own.

## Per-host values

The two hosts use different usernames. Rather than repeat one, `hosts.nix`
holds one attrset per host:

    { hostname, system, username, homeDirectory }

The macOS entry is not in `hosts.nix` — it names a directory account, and an
account-name convention is not guessable the way an email address is, so it
stays out of a public repo. It lives in `local/hosts-mac.nix`, which is gitignored.

Consequence: **macOS must be rebuilt with a `path:` flake ref.** The default
git ref sees only tracked files, so it cannot read `local/`; `path:`
copies the working tree instead. `hosts.nix` throws with that instruction
rather than falling back to a placeholder, so the wrong ref cannot quietly
build against the wrong user. The `rebuild` alias already uses the right ref.

NixOS is unaffected: its entry stays in `hosts.nix`, so `system.autoUpgrade`
keeps working against `github:` where no untracked file exists.

`flake.nix` passes the matching entry to the NixOS and darwin modules as
`specialArgs.host`, and to home-manager as `extraSpecialArgs.host`. Any module
that needs it takes `host` as an argument:

    { pkgs, host, ... }:
    {
      users.users.${host.username}.home = host.homeDirectory;
    }

Adding a host means adding an entry there and an output in `flake.nix`; no
module needs to learn a new name.

## Layout

    flake.nix                  inputs and both host outputs
    hosts.nix                  per-host values; the macOS entry lives in local/
    configuration.nix          NixOS: boot, desktop, services
    hardware-configuration.nix NixOS: generated hardware config
    darwin-configuration.nix   macOS: nix-darwin, homebrew casks, launchd
    home.nix                   home-manager entry point, imports home/*
    home/packages.nix          user CLI tools (Linux-only extras appended)
    home/shell.nix             git, zsh, starship
    home/ssh.nix               ssh defaults; account blocks are untracked
    home/terminal.nix          ghostty (cask on macOS, nixpkgs on Linux)
    home/neovim.nix            neovim, LSPs, plugins
    home/desktop.nix           Zen browser, Plasma settings
    home/kanata.kbd            caps lock as Esc (tap) / Ctrl (hold) on NixOS
    home/karabiner.nix         the same remap plus trackball buttons on macOS
    nvim/                      lua config, symlinked to ~/.config/nvim
    local/                     gitignored; see "Machine-local state"

Things that must be system-wide go in `configuration.nix` /
`darwin-configuration.nix`; everything else belongs under `home/`.

A few packages are not in nixpkgs for darwin — Ghostty needs an Xcode/Swift
build, so `meta.platforms` is Linux-only. Those come from `homebrew.casks` in
`darwin-configuration.nix`, while home-manager still owns the config by setting
`programs.<name>.package = null`. Ghostty reads `~/.config/ghostty/config` on
both platforms, so the settings themselves stay shared.

## Machine-local state

Everything tracked here is public, so anything identifying lives in `local/`,
which is gitignored. One folder, so it is one thing to back up and one thing to
copy to a new machine:

    local/hosts-mac.nix   the macOS host entry, imported by hosts.nix
    local/home.nix        home-manager module for host-specific agents and tools
    local/gitconfig       default git identity, pulled in by git `include`
    local/ssh_config      ssh host blocks, pulled in by ssh `Include`

The nix files are imported only if present, and git and ssh both ignore a
missing include, so a host without `local/` needs no special case — except that
`hosts.nix` deliberately throws for macOS rather than guess a username.

Field-level shapes are deliberately not documented here: spelling out what
these files contain would defeat keeping them out of a public repo. Keep a copy
of `local/` with whatever holds your other secrets — nothing else backs it up.

Two caveats:

- A `path:` flake ref copies the working tree into `/nix/store`, which is
  world-readable. `local/` is hidden from the internet, not from other accounts
  on the machine.
- `local/` can be promoted to a private git repo in place — `git init` inside
  it, or make it a symlink to a checkout elsewhere. Nothing outside it needs to
  change.

## Multiple GitHub accounts

GitHub refuses the same SSH key on more than one account, so accounts are
separated by transport rather than by key.

**SSH.** Any host block that names an account or an agent lives in
`local/ssh_config`, which is gitignored. `home/ssh.nix` pulls it in with
`Include`, emitted ahead of the tracked blocks — ssh is first-match-wins, so
that ordering is what gives the local file precedence. A missing file is
silently ignored, so a host without one needs no special case.

**HTTPS.** The credential helper stores one entry per hostname, so HTTPS can
serve exactly one account per host. Two accounts cannot both use HTTPS against
`github.com`: authenticating as the second overwrites the first, and pushes
that used to work start going to the wrong account. Note this is a property of
the remote URL, not of any config file here — nothing in this repo selects it.

So keep one account on SSH and at most one on HTTPS. To put a second account on
SSH instead, give it an alias in `local/ssh_config`:

    Host gh-other
        HostName github.com
        User git
        IdentityFile ~/.ssh/id_ed25519_other
        IdentitiesOnly yes

and use `git@gh-other:owner/repo.git` for its remotes. `IdentitiesOnly` belongs
on a block that names a key file — it stops ssh offering every agent identity to
the wrong account — but must stay off a block that relies on an agent, where it
would make ssh ignore that agent entirely.

## Automation

`.github/workflows/update-flake-lock.yml` bumps `flake.lock` every Saturday
12:00 UTC and commits to the default branch. The NixOS host's
`system.autoUpgrade` pulls that commit on Sundays at 04:00, so it only ever
deploys a lock recorded in git. The macOS host is updated manually.
