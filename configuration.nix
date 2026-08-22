{ config, pkgs, host, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.hostName = host.hostname;
  networking.networkmanager.enable = true;
  services.resolved.enable = true;
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
  users.users.${host.username} = {
    isNormalUser = true;
    description = "Nipuna G";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  # System-level programs
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
    wget
    curl
    git
  ];

  # Allow unfree packages (VS Code, Steam, etc.)
  nixpkgs.config.allowUnfree = true;

  # ExpressVPN
  services.expressvpn-qt.enable = true;

  # Kanata: caps lock as Esc (tap) / Ctrl (hold).
  hardware.uinput.enable = true;
  services.kanata = {
    enable = true;
    # Device restriction lives in the .kbd (linux-dev) so the single config
    # stays shared with the macOS host. A raw configFile overrides the module's
    # `devices` option, so setting it here would be silently ignored.
    keyboards.default.configFile = ./home/kanata.kbd;
  };
  systemd.services.kanata-default.serviceConfig.SupplementaryGroups = [ "uinput" "input" ];

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Auto-upgrade: pull the latest pushed commit of this flake and rebuild.
  # The lock itself is bumped in the repo by the update-flake-lock GitHub
  # Action, so this only ever deploys a pinned, recorded flake.lock. Runs
  # against the remote flake to avoid touching the local git tree.
  system.autoUpgrade = {
    enable = true;
    flake = "github:nipuna-g/dotfiles";
    # Honour the lockfile: don't pass --upgrade (that's a channel concept and
    # is meaningless for a flake pinned by flake.lock).
    upgrade = false;
    dates = "Sun 04:00";
    randomizedDelaySec = "45min";
    # Store the last-run time on disk so a missed run (machine off at 04:00)
    # fires on the next boot instead of being skipped for the week.
    persistent = true;
    # Never auto-reboot a desktop; kernel updates apply on the next manual reboot.
    allowReboot = false;
  };


  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
