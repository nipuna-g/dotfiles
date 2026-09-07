# Template for the aarch64-linux UTM VM host, not machine-generated like
# hardware-configuration.nix. UTM VMs don't exist until you create one, so
# there's no real hardware to scan yet -- the modules and layout below match
# what `nixos-generate-config` produces for a stock UTM/QEMU aarch64 VM using
# VirtIO devices, but the filesystem UUIDs are placeholders.
#
# After installing (see README "UTM VM"), run `nixos-generate-config
# --root /mnt` on the VM and copy its fileSystems/swapDevices/boot.initrd
# stanzas in here, replacing the placeholders below. Everything else here can
# stay.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "virtio_pci" "virtio_blk" "virtio_scsi" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # REPLACE with the UUIDs from `nixos-generate-config` after install.
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/0000-0000";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
