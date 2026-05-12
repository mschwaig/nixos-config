{ config, pkgs, ... }:
{
  imports =
    [ ./hardware-configuration/lair.nix
      ../addins/server
      ../addins/server/binary-cache.nix
    ];

  boot.initrd.kernelModules = [ "r8169" ];

  networking.hostName = "lair";
  networking.hostId = "03b30d7b";
  networking.interfaces.enp3s0.useDHCP = true;

  system.stateVersion = "19.09";
}
