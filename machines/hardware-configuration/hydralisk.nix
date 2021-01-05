# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "rpool/enc/root";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "rpool/enc/nix";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "rpool/enc/home";
      fsType = "zfs";
    };

  fileSystems."/tmp" =
    { device = "rpool/enc/tmp";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/C602-9FEC";
      fsType = "vfat";
    };

  swapDevices = [ ];

}
