# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration/mutalisk.nix
      # Include device-specific config from nixos-hardware channel
      # <nixos-hardware/lenovo/thinkpad/t480s>
      ../addins/client
      ../addins/portable
      ../addins/jku-ins-network.nix
    ];

  networking.hostName = "mutalisk";
  networking.hostId = "ed7fb7da";

  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;

  users.users.mschwaig = {
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnU1xQN50B54S98io0kH1xElc9yNqmZMPF0s8QASLaB" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}

