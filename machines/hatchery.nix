{ config, pkgs, ... }:
{
  imports =
    [ ./hardware-configuration/hatchery.nix
      ../addins/server
    ];

  boot = {
    initrd.kernelModules = [ "e1000e" ];
    zfs = {
      forceImportRoot = false;
      forceImportAll = false;
    };
  };

  networking.hostName = "hatchery";
  networking.hostId = "78f04373";
  networking.interfaces.eno1.useDHCP = true;

  users.users.mschwaig.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG+rH8kZEx4X1oTny9jSVI8RZenGKwA7iHURsrkuWCYZ" # srv (for backups)
  ];

  system.stateVersion = "20.03";
}