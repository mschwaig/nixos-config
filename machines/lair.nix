# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration/lair.nix
      ../addins/server
      ../addins/server/weechat.nix
    ];

  # ssh instance for entering disk passphrase on boot
  boot = {
    initrd = {
      kernelModules = [ "r8169" ];
      network = {
        enable = true;
        ssh = {
          enable = true;
          # different port because a different key is used
          port = 2222;
          hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
          authorizedKeys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNdCt+2TSagVo60uRwVcmqpnw4dmObs1v8texBvAoCR" # mutalisk
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnU1xQN50B54S98io0kH1xElc9yNqmZMPF0s8QASLaB" # hydralisk
          ];
        };
        # this will automatically load the zfs password prompt on login
        # and kill the other prompt so boot can continue
        postCommands = ''
          zpool import tank
          echo "zfs load-key -a; killall zfs" >> /root/.profile
        '';
      };
    };
  };

  networking.hostName = "srv"; # Define your hostname.
  networking.hostId = "03b30d7b";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;

  users.users.mschwaig = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNdCt+2TSagVo60uRwVcmqpnw4dmObs1v8texBvAoCR" # mutalisk
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnU1xQN50B54S98io0kH1xElc9yNqmZMPF0s8QASLaB" # hydralisk
    ];
  };

  programs.fish.enable = true;

  programs.vim.defaultEditor = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

