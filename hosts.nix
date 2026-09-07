# Consumed via specialArgs (host modules) and extraSpecialArgs (home-manager).
let
  local = ./local/hosts-mac.nix;
in
{
  nixos = {
    hostname = "nixos";
    system = "x86_64-linux";
    username = "nipuna";
    homeDirectory = "/home/nipuna";
  };

  # aarch64 NixOS guest, for a UTM VM on an Apple Silicon Mac. Its own
  # hardware-configuration-vm.nix (virtio devices, systemd-boot) instead of
  # the desktop's nvme/kvm-amd one.
  # hostname must match the nixosConfigurations attr name below -- the
  # `rebuild`/`update` shell aliases and system.autoUpgrade both build
  # `#${host.hostname}`.
  vm = {
    hostname = "vm";
    system = "aarch64-linux";
    username = "nipuna";
    homeDirectory = "/home/nipuna";
  };

  # Untracked, so this needs a `path:` flake ref; the default git ref sees only
  # tracked files. Throws rather than falling back, so a wrong ref cannot
  # silently build against the wrong user.
  mac =
    if builtins.pathExists local then
      import local
    else
      throw "local/hosts-mac.nix not found -- rebuild with: darwin-rebuild switch --flake path:$HOME/dotfiles#mac";
}
