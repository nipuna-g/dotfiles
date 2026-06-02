{ config, pkgs, lib, zen-browser, ... }:

let
  zen = pkgs.wrapFirefox
    zen-browser.packages.x86_64-linux.zen-browser-unwrapped
    {
      extraPrefs = ''
        lockPref("extensions.autoDisableScopes", 0);
      '';
      extraPolicies.ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "normal_installed";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "normal_installed";
        };
        "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/return-youtube-dislikes/latest.xpi";
          installation_mode = "normal_installed";
        };
        "sponsorBlocker@ajay.app" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/sponsorblock/latest.xpi";
          installation_mode = "normal_installed";
        };
      };
    };
in

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
    zen
    deluge
    vlc
    gnutar
    which
    vscode
    obsidian 
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

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
      lua-language-server
      typescript-language-server
      pyright
      rust-analyzer
      fd
    ];
    plugins = with pkgs.vimPlugins; [
      tokyonight-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      plenary-nvim
      telescope-nvim
      telescope-fzf-native-nvim
      (nvim-treesitter.withPlugins (p: with p; [
        nix lua typescript javascript tsx python rust
        json yaml toml markdown html css bash
      ]))
      nvim-web-devicons
      nui-nvim
      neo-tree-nvim
      gitsigns-nvim
      lualine-nvim
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
        height = 32;
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
        hiding = "autohide";
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
