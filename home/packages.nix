{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    claude-code
    home-manager
    nodejs
    chromium
    deluge
    vlc
    gnutar
    which
    vscode
    obsidian
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
  ];
}
