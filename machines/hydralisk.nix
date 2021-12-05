# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration/hydralisk.nix
      ../addins/client
      ../addins/client/desktop/gpu-passthrough.nix
    ];

  # stop running out of RAM with diffoscope
  zramSwap.enable = true;

  networking.hostName = "hydralisk";
  networking.hostId = "46b5a21f";

  networking.interfaces.enp39s0.useDHCP = true;
  networking.interfaces.enp45s0.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;

  networking.wireless.iwd.enable = true;

  environment.systemPackages = with pkgs; [
    pciutils reaper

    virtmanager looking-glass-client
  ];

  users.users.mschwaig = {
    extraGroups = [ "libvirtd" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNdCt+2TSagVo60uRwVcmqpnw4dmObs1v8texBvAoCR" # mutalisk
    ];
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      qemuOvmf = true;
      qemuRunAsRoot = false;
      onBoot = "ignore";
      onShutdown = "shutdown";
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.03"; # Did you read the comment?
}

