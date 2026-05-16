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
    ghostty
    brave
    deluge
    vlc
    gnutar
    which
    vscode
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
}
