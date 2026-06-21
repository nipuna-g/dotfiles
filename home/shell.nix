{ pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Nipuna G";
      user.email = "nipuna@nipuna.dev";
      aliases = {
        st     = "status";
        co     = "checkout";
        br     = "branch";
        lg     = "log --oneline --graph --decorate";
        undo   = "reset HEAD~1 --mixed";
        staged = "diff --cached";
      };
    };
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

      rebuild = if pkgs.stdenv.isDarwin
        then "home-manager switch --flake ~/dotfiles#nipuna"
        else "sudo nixos-rebuild switch";
      update = if pkgs.stdenv.isDarwin
        then "cd ~/dotfiles && nix flake update && home-manager switch --flake ~/dotfiles#nipuna"
        else "cd ~/dotfiles && nix flake update && sudo nixos-rebuild switch";
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
