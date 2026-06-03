{ pkgs, ... }:

{
  home.username = "nipuna";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/nipuna" else "/home/nipuna";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  imports = [
    ./home/packages.nix
    ./home/shell.nix
    ./home/terminal.nix
    ./home/neovim.nix
    ./home/desktop.nix
  ];
}
