{ pkgs, ... }:

{
  system.primaryUser = "nipuna";
  system.stateVersion = 5;

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.zsh.enable = true;

  users.users.nipuna = {
    name = "nipuna";
    home = "/Users/nipuna";
  };

  environment.systemPackages = with pkgs; [
    wget
    curl
    git
  ];

  # Kanata: caps lock as Esc (tap) / Ctrl (hold).
  # Requires the Karabiner DriverKit VirtualHIDDevice to be installed once:
  # https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases
  launchd.daemons.kanata.serviceConfig = {
    ProgramArguments = [
      "${pkgs.kanata}/bin/kanata"
      "-c"
      "${./home/kanata.kbd}"
    ];
    KeepAlive = true;
    RunAtLoad = true;
    StandardOutPath = "/var/log/kanata.log";
    StandardErrorPath = "/var/log/kanata.err.log";
  };
}
