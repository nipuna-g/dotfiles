{ config, pkgs, ... }:

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
  networking.hostName = "nixos";
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
  users.users.nipuna = {
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

  # Ollama: local LLM runtime.
  # ollama-vulkan drives the AMD GPU (RX 9060 XT, 16 GB) via the Mesa/RADV
  # Vulkan driver. Preferred over ollama-rocm here because RDNA4 ROCm support
  # is new and finicky; Vulkan works on the stock graphics stack with no
  # gfx-version overrides.
  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
    loadModels = [
      "gpt-oss:20b"      # fast MoE general/coding daily driver (~12 GB)
      "qwen3:30b-a3b"    # stronger MoE, ~3B active so partial offload stays fast
    ];
  };

  # Open WebUI: ChatGPT-style frontend for the Ollama service above.
  # Port 11435 (next to Ollama's 11434) keeps it clear of web-dev defaults
  # like 3000/5173/8080. Visit http://localhost:11435.
  services.open-webui = {
    enable = true;
    port = 11435;
    environment = {
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
      WEBUI_AUTH = "False";          # skip login on a local single-user box
      ANONYMIZED_TELEMETRY = "False";
    };
  };

  # Kanata: caps lock as Esc (tap) / Ctrl (hold).
  hardware.uinput.enable = true;
  services.kanata = {
    enable = true;
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
    
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.11";
}
