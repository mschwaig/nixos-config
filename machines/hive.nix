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
      inputs.home-manager.nixosModules.home-manager
    ];

  networking.hostName = "hive";
  networking.hostId = "e3a48e7a";

  networking.interfaces.enp191s0.useDHCP = true;

  # Ollama AI model server
  services.ollama = {
    enable = true;
    package = (pkgs.ollama.override { acceleration = "rocm"; });
    acceleration = "rocm";
    rocmOverrideGfx = "11.0.2";
    host = "0.0.0.0"; # Listen on all interfaces
    port = 11434;
  };

  # Open firewall for ollama
  networking.firewall.allowedTCPPorts = [ 11434 ];

  # Add extra experimental features from client configs
  nix = {
    settings = {
      substituters = [ "https://cache.nixos.org" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations impure-derivations
    '';
  };

  # System packages
  environment.systemPackages = with pkgs; [
    amdgpu_top
    llama-cpp-vulkan
    llama-swap
  ];

  # Fetch the GLM-4.5-Air model parts from Hugging Face
  environment.etc."llama-models/GLM-4.5-Air-Q4_K_M-00001-of-00002.gguf" = {
    source = pkgs.fetchurl {
      url = "https://huggingface.co/unsloth/GLM-4.5-Air-GGUF/resolve/main/Q4_K_M/GLM-4.5-Air-Q4_K_M-00001-of-00002.gguf";
      hash = "sha256-vE8oKY+wX/mLdpJfbBQ+cRp/stXOtO1LfB9luMhLm5s=";
    };
  };

  environment.etc."llama-models/GLM-4.5-Air-Q4_K_M-00002-of-00002.gguf" = {
    source = pkgs.fetchurl {
      url = "https://huggingface.co/unsloth/GLM-4.5-Air-GGUF/resolve/main/Q4_K_M/GLM-4.5-Air-Q4_K_M-00002-of-00002.gguf";
      hash = "sha256-WBJE206BmJQ8C4CcgXMNaOJOCgqN5p5NoQH/pIIFXCc=";
    };
  };

  # Llama-swap service configuration
  services.llama-swap = {
    enable = true;
    port = 11435; # Different from ollama port
    openFirewall = true;
    settings = 
      let
        llama-server = lib.getExe' pkgs.llama-cpp-vulkan "llama-server";
      in
      {
        healthCheckTimeout = 60;
        models = {
          "glm-4.5-air-q4km" = {
            # llama.cpp automatically detects and loads multi-part GGUF files
            cmd = "${llama-server} --port \${PORT} -m /etc/llama-models/GLM-4.5-Air-Q4_K_M-00001-of-00002.gguf -ngl 99 --no-webui";
            aliases = [ "glm-4.5-air" ];
          };
        };
      };
  };

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
