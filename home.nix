{ lib, host, ... }:

{
  home.username = host.username;
  home.homeDirectory = host.homeDirectory;
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  imports = [
    ./home/packages.nix
    ./home/shell.nix
    ./home/terminal.nix
    ./home/neovim.nix
    ./home/ssh.nix
    ./home/gh.nix
    ./home/desktop.nix
    ./home/karabiner.nix
    ./home/pi.nix
  ]
  # Untracked and so invisible to the default git ref; needs a path: flake ref.
  ++ lib.optional (builtins.pathExists ./local/home.nix) ./local/home.nix;
}
