{ pkgs, lib, host, ... }:

{
  nix.enable = false;

  system.primaryUser = host.username;
  system.stateVersion = 5;

  nixpkgs.hostPlatform = host.system;
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.zsh.enable = true;

  users.users.${host.username} = {
    name = host.username;
    home = host.homeDirectory;
  };

  environment.systemPackages = with pkgs; [
    wget
    curl
    git
  ];

  # nix-darwin generates its own /etc/zprofile, and that one never calls
  # /usr/libexec/path_helper -- so /etc/paths.d/homebrew is dead config here and
  # nothing brew installs is on PATH. Append the prefix ourselves; mkAfter keeps
  # it behind the nix profiles so nixpkgs always wins a name collision.
  environment.systemPath = lib.mkAfter [ "/opt/homebrew/bin" "/opt/homebrew/sbin" ];

  homebrew = {
    enable = true;
    
    onActivation.cleanup = "uninstall";

    casks = [
      "chromium"
      "visual-studio-code"
      "zed"
      "raycast"
      # Configured in home/karabiner.nix.
      "karabiner-elements"
      # Not in nixpkgs for darwin; home/terminal.nix manages its config.
      "ghostty"
      # The zen-browser flake builds for Linux only; see home/desktop.nix.
      "zen"
    ];

    # Any App Store app not listed here gets uninstalled.
    masApps.Amphetamine = 937984704;
  };

  # Sleep (unlike screen lock) kills running processes; keep it long.
  power.sleep.computer = 60;
}
