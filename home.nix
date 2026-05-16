{ config, pkgs, lib, ... }:

{
  home.username = "nipuna";
  home.homeDirectory = "/home/nipuna";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    home-manager
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
    userName = "Nipuna Gunathilake";
    userEmail = "nipuna@nipuna.dev";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
