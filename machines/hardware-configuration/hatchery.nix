# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "ums_realtek" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "rpool/enc/root";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/5089-842D";
      fsType = "vfat";
    };

  fileSystems."/tmp" =
    { device = "rpool/enc/tmp";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "rpool/enc/home";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "rpool/enc/nix";
      fsType = "zfs";
    };

  boot.zfs.extraPools = [ "bkptank" ];

  swapDevices = [ ];

  nix.settings.max-jobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
