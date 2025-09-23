{ config, inputs, pkgs, lib, ... }:
let
  llama-cpp = pkgs.llama-cpp-vulkan;
  llama-server = lib.getExe' llama-cpp "llama-server";
in
{
  # Fetch models and create environment entries
  environment.etc = let
    models = import ./models.nix { inherit pkgs; };
  in
    lib.mapAttrs' (name: value: 
      lib.nameValuePair "llama-models/${name}" { source = value; }
    ) models;

  # Llama-swap service configuration
  systemd.services.llama-swap.environment.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/amd_icd64.json";
  
  services.llama-swap = {
    enable = true;
    port = 11435; # Different from ollama port
    openFirewall = true;
    settings = {
      healthCheckTimeout = 60;
      models = {
        "glm-4.5-air-q4km" = {
          # llama.cpp automatically detects and loads multi-part GGUF files
          cmd = "${llama-server} --port \${PORT} -m /etc/llama-models/GLM-4.5-Air-Q4_K_M-00001-of-00002.gguf -ngl 20 --no-webui";
          aliases = [ "glm-4.5-air" ];
        };
      };
    };
  };

  # Add llama-cpp and llama-swap to system packages
  environment.systemPackages = [
    llama-cpp
    pkgs.llama-swap
  ];
}