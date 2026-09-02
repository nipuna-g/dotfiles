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
    # Wayland clipboard CLI; zsh binds vi-mode p/P through it (see shell.nix).
    wl-clipboard
    kdePackages.kate
    chromium
    deluge
    vlc
    vscode
    obsidian
  ];
}
