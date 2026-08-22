{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    claude-code
    pi-coding-agent
    home-manager
    nodejs
    gnutar
    which
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
    kanata
  ] ++ lib.optionals stdenv.isLinux [
    kdePackages.kate
    chromium
    deluge
    vlc
    vscodium
    obsidian
  ];
}
