{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    # KDE Connect
    allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
    allowedUDPPortRanges = [{ from = 1714; to = 1764; }];
  };

  # Locale
  time.timeZone = "Asia/Singapore";
  i18n.defaultLocale = "en_SG.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "en_SG.UTF-8";
    LC_IDENTIFICATION = "en_SG.UTF-8";
    LC_MEASUREMENT    = "en_SG.UTF-8";
    LC_MONETARY       = "en_SG.UTF-8";
    LC_NAME           = "en_SG.UTF-8";
    LC_NUMERIC        = "en_SG.UTF-8";
    LC_PAPER          = "en_SG.UTF-8";
    LC_TELEPHONE      = "en_SG.UTF-8";
    LC_TIME           = "en_SG.UTF-8";
  };

  # Desktop: KDE Plasma 6
  services.xserver.enable = true;
  services.xserver.xkb = { layout = "us"; variant = ""; };
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Printing
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin ];

  # User
  users.users.nipuna = {
    isNormalUser = true;
    description = "Nipuna G";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  # System-level programs
  programs.firefox.enable = true;
  programs.kdeconnect.enable = true;
  programs.nix-ld.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  programs.zsh.enable = true;

  # System packages — keep this list for things that must be
  # system-wide. User tools belong in home.nix instead.
  environment.systemPackages = with pkgs; [
    neovim
    wget
    curl
    git  # added — needed by Nix flakes itself
  ];

  # Allow unfree packages (VS Code, Steam, etc.)
  nixpkgs.config.allowUnfree = true;

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
