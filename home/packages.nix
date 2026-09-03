{ pkgs, lib, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;
in
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

    devcontainer
  ] ++ lib.optionals isLinux [
    # Wayland clipboard CLI; zsh binds vi-mode p/P through it (see shell.nix).
    wl-clipboard
    kdePackages.kate
    chromium
    deluge
    vlc
    obsidian
    zed-editor
  ] ++ lib.optionals isDarwin [
    # colima runs the Linux VM docker-client talks to; NixOS uses virtualisation.docker.
    colima
    docker-client
    docker-compose
  ];

  # nixpkgs docker-compose doesn't install its cli-plugin, so `docker compose` needs this link.
  home.file.".docker/cli-plugins/docker-compose" = lib.mkIf isDarwin {
    source = "${pkgs.docker-compose}/libexec/docker/cli-plugins/docker-compose";
  };
}
