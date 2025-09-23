# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, inputs, pkgs, lib, ... }:
{
  imports =
    [
      inputs.nixos-hardware.nixosModules.framework-desktop-amd-ai-max-300-series
      inputs.disko.nixosModules.disko
      ./hardware-configuration/hive.nix
      ./disks/hive.nix
      ../addins/server
      ../addins/llm
      inputs.home-manager.nixosModules.home-manager
    ];

  networking.hostName = "hive";
  networking.hostId = "e3a48e7a";

  networking.interfaces.enp191s0 = {
    useDHCP = false;
    ipv4.addresses = [{
      address = "192.168.248.48";
      prefixLength = 24;
    }];
  };
  networking.defaultGateway = "192.168.248.1";
  networking.nameservers = [ "192.168.248.1" ];
  networking.domain = "ins.jku.at";
  networking.search = [ "ins.jku.at" ];
  networking.firewall.trustedInterfaces = [ "tailscale0" ];


  # Add extra experimental features from client configs
  nix = {
    settings = {
      substituters = lib.mkForce [ "https://cache.nixos.org" ];
      trusted-public-keys = lib.mkForce [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations impure-derivations
    '';
  };

  # Enable AMDVLK driver for better compute performance
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  # System packages
  environment.systemPackages = with pkgs; [
    amdgpu_top
  ];

  # Home-manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.mschwaig = { pkgs, ... }: {
      imports = [ ../home/text ];
      home.stateVersion = "22.11";
    };
    extraSpecialArgs = {
      inherit inputs;
    };
  };

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
