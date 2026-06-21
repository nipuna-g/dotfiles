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
}
