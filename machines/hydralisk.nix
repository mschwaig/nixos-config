# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration/hydralisk.nix
      ../addins/client
      ../addins/encrypted-zfs-root
    ];

  boot.initrd.kernelModules = [ "amdgpu" ];

  networking.hostName = "hydralisk";
  networking.hostId = "46b5a21f";

  networking.interfaces.enp40s0.useDHCP = true;
  networking.interfaces.enp46s0.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;

  environment.systemPackages = (with pkgs; [
    pciutils reaper

    virt-manager looking-glass-client
  ]) ++ (with pkgs.rocmPackages; [
    rocminfo rocm-smi
  ]);

  hardware.opengl.extraPackages = [
    pkgs.rocmPackages.clr.icd
  ];


  systemd.services.ollama.environment.OLLAMA_ORIGINS = "https://hydralisk.van-duck.ts.net,http://localhost:*";
  services = {
    spotifyd.enable = true;
    caddy = {
      enable = true;
      virtualHosts."hydralisk.van-duck.ts.net:11435".extraConfig = ''
        reverse_proxy hydralisk.van-duck.ts.net:11434
      '';
      virtualHosts."hydralisk.van-duck.ts.net".extraConfig = ''
        reverse_proxy hydralisk.van-duck.ts.net:8080
      '';
    };
    tailscale.permitCertUid = "caddy";

    ollama = {
      enable = true;
      package = (pkgs.ollama.override { acceleration = "rocm"; });
      acceleration = "rocm";
      rocmOverrideGfx = "11.0.2";
      #host = "hydralisk.van-duck.ts.net";
    };
    nextjs-ollama-llm-ui = {
      enable = true;
      port = 8080;
      hostname = "hydralisk.van-duck.ts.net";
      ollamaUrl = "https://hydralisk.van-duck.ts.net:11435";
    };
  };

  users.users.mschwaig = {
    extraGroups = [ "libvirtd" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHNdCt+2TSagVo60uRwVcmqpnw4dmObs1v8texBvAoCR" # mutalisk
    ];
  };

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        ovmf.enable = true;
        runAsRoot = false;
      };
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

