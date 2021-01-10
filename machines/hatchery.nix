# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration/hatchery.nix
      ../addins/server
    ];

  # ssh instance for entering disk passphrase on boot
  boot = {
    initrd = {
      # find the correct driver at /sys/class/net/eno1/device/driver
      # see: https://unix.stackexchange.com/a/420515
      kernelModules = [ "e1000e" ];
      network = {
        enable = true;
        ssh = {
          enable = true;
          # different port because a different key is used
          port = 2222;
          # host key generated using
          # ssh-keygen -t ed25519 -N "" -f /etc/secrets/initrd/ssh_host_ed25519_key
          hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
          authorizedKeys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNdCt+2TSagVo60uRwVcmqpnw4dmObs1v8texBvAoCR" # mutalisk
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnU1xQN50B54S98io0kH1xElc9yNqmZMPF0s8QASLaB" # hydralisk
          ];
        };
        # this will automatically load the zfs password prompt on login
        # and kill the other prompt so boot can continue
        postCommands = ''
          zpool import bkptank
          echo "zfs load-key rpool/enc; killall zfs" >> /root/.profile
        '';
      };
    };
  };

  boot.zfs.forceImportRoot = false;
  boot.zfs.forceImportAll = false;

  networking.hostName = "hatchery";
  networking.hostId = "78f04373";

  networking.interfaces.eno1.useDHCP = true;

  users.users.mschwaig = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNdCt+2TSagVo60uRwVcmqpnw4dmObs1v8texBvAoCR" # mutalisk
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnU1xQN50B54S98io0kH1xElc9yNqmZMPF0s8QASLaB" # hydralisk
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG+rH8kZEx4X1oTny9jSVI8RZenGKwA7iHURsrkuWCYZ" # srv (for backups)
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}

