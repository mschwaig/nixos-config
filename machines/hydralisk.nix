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

#  systemd.services.ollama.environment.OLLAMA_ORIGINS = "*";

  services = {
    spotifyd.enable = true;
    caddy = {
      enable = true;

      virtualHosts."hydralisk.van-duck.ts.net".extraConfig = ''
        # Forward to the NextJS web UI, preserving the original host header
        reverse_proxy http://127.0.0.1:8080 {
          header_up Host {host}
        }
      '';

      # the webui does not use this proxy,
      # instead it proxies requests to ollama through itself
      virtualHosts."hydralisk.van-duck.ts.net:11435".extraConfig = ''
        # Block requests with Origin/Referer headers (from browsers)
        @browser {
          # we could potentially also allow only https://hydralisk.van-duck.ts.net through here
          header Origin *
        }
        @browser_referer {
          header Referer *
        }
        # block websocket connections
        @websocket {
          header Upgrade websocket
        }
        
        # Respond with 403 Forbidden to browser requests and websockets
        respond @browser 403
        respond @browser_referer 403
        respond @websocket 403

        reverse_proxy 127.0.0.1:11434
      '';
    };
    tailscale.permitCertUid = "caddy";

    ollama = {
      enable = true;
      package = (pkgs.ollama.override { acceleration = "rocm"; });
      acceleration = "rocm";
      rocmOverrideGfx = "11.0.2";
      host = "0.0.0.0";
      environmentVariables = {
        OLLAMA_NUM_CTX="32768";
      };
    };
    nextjs-ollama-llm-ui = {
      enable = true;
      port = 8080;
      ollamaUrl = "http://127.0.0.1:11434";
    };
  };

  users.users.mschwaig = {
    extraGroups = [ "libvirtd" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKnthNhO1+KJ27ctGf+zUtYNgUORUegCm+4CX/X1W9+S" # mutalisk
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

