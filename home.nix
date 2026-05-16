{ config, pkgs, lib, ... }:

{
  home.username = "nipuna";
  home.homeDirectory = "/home/nipuna";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    claude-code
    home-manager
    nodejs_22
    brave
    deluge
    vlc
    gnutar
    which
    vscode
    nerd-fonts.jetbrains-mono

    eza
    bat
    btop
    ripgrep
    fzf
    zoxide
  ] ++ lib.optionals stdenv.isLinux [
    kdePackages.kate
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "Nipuna G";
      user.email = "nipuna@nipuna.dev";
    };
  };

  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-size = 13;
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
      ls   = "eza --icons";
      ll   = "eza -la --icons --git";
      lt   = "eza --tree --icons --level=2";
      cat  = "bat";
      top  = "btop";
      grep = "rg";

      rebuild = "sudo nixos-rebuild switch";
      update  = "cd ~/dotfiles && nix flake update && sudo nixos-rebuild switch";
    };
    initContent = ''
      eval "$(zoxide init zsh --cmd z)"
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;

      format = lib.concatStrings [
        "╭── "
        "$directory"
        "$git_branch"
        "$git_status"
        "$nix_shell"
        "$line_break"
	"╰─"
        "$character"
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
        symbol = "";
        style  = "bold cyan";
        format = "[$symbol]($style) ";
      };

      character = {
        success_symbol = "[▶](bold green)";
        error_symbol   = "[▶](bold red)";

      };
    };
  };
}
