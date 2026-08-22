{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;

    # Not in nixpkgs for darwin; there the app comes from the homebrew cask.
    package = if pkgs.stdenv.hostPlatform.isLinux then pkgs.ghostty else null;

    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-size = 13;
    };
  };
}
