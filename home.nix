{ config, pkgs, lib, ... }:

{
  home.username = "nipuna";
  home.homeDirectory = "/home/nipuna";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    nixd
    nixfmt

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
      aliases = {
        st = "status";
        co = "checkout";
        br = "branch";
        lg = "log --oneline --graph --decorate";
        undo = "reset HEAD~1 --mixed";
        staged = "diff --cached";
      };
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
      export EDITOR=nvim
      export VISUAL=nvim
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
        symbol = "";
        style  = "bold cyan";
        format = "[$symbol]($style) ";
      };
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;
      extraPackages = with pkgs; [
      nixd
      nixfmt
    ];
  };

  xdg.configFile."nvim" = {
    source = ./nvim;
    recursive = true;
  };

  programs.plasma = {
    enable = true;

    panels = [
      {
        location = "top";
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.appmenu"
          "org.kde.plasma.panelspacer"
          {
            systemTray = {
              icons.spacing = "medium";
            };
          }
          "org.kde.plasma.marginsseparator"
          {
            digitalClock = {
              time.format = "24h";
              date = {
                enable = true;
                position = "besideTime";
                format.custom = "MM-d ddd";
              };
              font = {
                bold = true;
                size = 8;
                family = "JetBrainsMono Nerd Font";
              };
            };
          }
          "org.kde.plasma.lock_logout"
        ];
      }
      {
        location = "left";
        widgets = [
          {
            iconTasks = {
              launchers = [
                "applications:systemsettings.desktop"
                "preferred://filemanager"
                "preferred://browser"
                "applications:com.mitchellh.ghostty.desktop"
              ];
            };
          }
        ];
      }
    ];
  };
}
