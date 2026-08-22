{ pkgs, lib, zen-browser, ... }:

let
  zen = pkgs.wrapFirefox
    zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped
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
  # macOS gets Zen from the homebrew cask instead; the flake is Linux-only.
  home.packages = lib.optionals pkgs.stdenv.isLinux [ zen ];

  programs.plasma = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;

    # Elecom Huge trackball: hold BTN_TASK (evdev button 279) and roll the ball
    # to scroll. KWin stores per-device input settings in kcminputrc under a
    # [Libinput][vendor][product][name] group; vendor 1390 / product 284 are the
    # Getech "HUGE TrackBall". ScrollMethod is a libinput bitmask where 4 =
    # scroll-on-button-down; ScrollButton is the held button's evdev code.
    # plasma-manager splits the group name on "/" into KConfig's nested
    # [Libinput][1390][284][Getech HUGE TrackBall] group header.
    configFile.kcminputrc."Libinput/1390/284/Getech HUGE TrackBall" = {
      ScrollMethod = 4;
      ScrollButton = 279;
    };

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
                "applications:steam.desktop"
              ];
            };
          }
        ];
      }
    ];
  };
}
