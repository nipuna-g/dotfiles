{ pkgs, lib, host, ... }:

let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  switchCommand = if isDarwin then "darwin-rebuild" else "nixos-rebuild";
  # path: rather than the default git ref, which cannot see local/.
  flakeRef = if isDarwin then "path:$HOME/dotfiles" else "~/dotfiles";
in
{
  programs.git = {
    enable = true;

    settings = {
      alias = {
        st     = "status";
        co     = "checkout";
        br     = "branch";
        lg     = "log --oneline --graph --decorate";
        undo   = "reset HEAD~1 --mixed";
        staged = "diff --cached";
      };
    };

    includes = [
      # Default identity, untracked; see README "Machine-local state".
      { path = "~/dotfiles/local/gitconfig"; }

      # After the include so it wins here.
      {
        condition = "gitdir:~/dotfiles/";
        contents = {
          user.name = "Nipuna G";
          user.email = "nipuna@nipuna.dev";
          user.signingKey = "";
          commit.gpgSign = false;
          tag.gpgSign = false;
        };
      }
    ];
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 10000;
      ignoreDups = true;
      share = true;
    };
    shellAliases = {
      ls  = "eza --icons";
      ll  = "eza -la --icons --git";
      lt  = "eza --tree --icons --level=2";
      cat = "bat";
      top = "btop";
      grep = "rg";
      code = "codium";

      # home-manager is a host module, so there is no homeConfigurations output.
      rebuild = "sudo ${switchCommand} switch --flake ${flakeRef}#${host.hostname}";
      update = "cd ~/dotfiles && nix flake update && sudo ${switchCommand} switch --flake ${flakeRef}#${host.hostname}";
    };
    initContent = ''
      eval "$(zoxide init zsh --cmd z)"
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh
      export EDITOR=nvim
      export VISUAL=nvim

      # Prefix-filtered history search on arrow keys
      autoload -U up-line-or-beginning-search down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search
      bindkey '^[[A' up-line-or-beginning-search
      bindkey '^[[B' down-line-or-beginning-search
      [[ -n "$terminfo[kcuu1]" ]] && bindkey "$terminfo[kcuu1]" up-line-or-beginning-search
      [[ -n "$terminfo[kcud1]" ]] && bindkey "$terminfo[kcud1]" down-line-or-beginning-search
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;

      format = lib.concatStrings [
        "╭─ "
        "$directory"
        "$git_branch"
        "$git_status"
        "$nix_shell"
        "$line_break"
        "╰─ "
      ];

      directory = {
        truncation_length = 3;
        truncate_to_repo  = true;
        style = "bold blue";
      };

      git_branch = {
        symbol = " ";
        style  = "bold purple";
      };

      git_status = {
        modified  = "!";
        untracked = "?";
        staged    = "+";
        deleted   = "✘";
        style     = "bold red";
      };

      nix_shell = {
        symbol = "";
        style  = "bold cyan";
        format = "[$symbol]($style) ";
      };
    };
  };
}
