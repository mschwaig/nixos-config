# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, inputs, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      inputs.nixos-hardware.nixosModules.framework-desktop-amd-ai-max-300-series
      inputs.disko.nixosModules.disko
      ./hardware-configuration/hive.nix
      ./disks/hive.nix
      ../addins/server
    ];

  networking.hostName = "hive";
  networking.hostId = "4a9b2c7d"; # Generated unique hostId

  networking.interfaces.enp191s0.useDHCP = true;

  users.users.mschwaig = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKnthNhO1+KJ27ctGf+zUtYNgUORUegCm+4CX/X1W9+S" # mutalisk
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnU1xQN50B54S98io0kH1xElc9yNqmZMPF0s8QASLaB" # hydralisk
    ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "24.05"; # Did you read the comment?
}