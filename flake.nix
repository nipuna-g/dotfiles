{
  description = "Nipuna's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-code.url = "github:sadjow/claude-code-nix";

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    expressvpn-qt = {
      url = "github:nipuna-g/expressvpn-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, claude-code, plasma-manager, zen-browser, expressvpn-qt, ... }:
  let
    hosts = import ./hosts.nix;

    # A function of host: hosts can use different usernames.
    hmSharedConfig = host: {
      nixpkgs.overlays = [ claude-code.overlays.default ];
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ];
      home-manager.users.${host.username} = import ./home.nix;
      home-manager.extraSpecialArgs = { inherit zen-browser host; };
    };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit (hosts.nixos) system;
      specialArgs = { host = hosts.nixos; };
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix
        expressvpn-qt.nixosModules.default
        home-manager.nixosModules.home-manager
        (hmSharedConfig hosts.nixos)
      ];
    };

    # aarch64-linux guest for a UTM VM on an Apple Silicon Mac. Shares
    # configuration.nix with the desktop (x86_64-only bits like Steam and
    # ExpressVPN are guarded there); only the hardware config differs.
    nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
      inherit (hosts.vm) system;
      specialArgs = { host = hosts.vm; };
      modules = [
        ./configuration.nix
        ./hardware-configuration-vm.nix
        expressvpn-qt.nixosModules.default
        home-manager.nixosModules.home-manager
        (hmSharedConfig hosts.vm)
      ];
    };

    darwinConfigurations.mac = nix-darwin.lib.darwinSystem {
      inherit (hosts.mac) system;
      specialArgs = { host = hosts.mac; };
      modules = [
        ./darwin-configuration.nix
        home-manager.darwinModules.home-manager
        (hmSharedConfig hosts.mac)
      ];
    };
  };
}
