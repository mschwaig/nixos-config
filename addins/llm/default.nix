{ config, inputs, pkgs, lib, ... }:
let
  llama-cpp = pkgs.llama-cpp-rocm;
  llama-server = lib.getExe' llama-cpp "llama-server";
in
{
  environment.etc = let
    models = import ./models.nix { inherit pkgs; };
  in
    lib.mapAttrs' (name: value: 
      lib.nameValuePair "llama-models/${name}" { source = value; }
    ) models;

  # not sure if this works for switching to the other vulkan driver
  # systemd.services.llama-swap.environment.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/amd_icd64.json";
  
  services.llama-swap = {
    enable = true;
    port = 11434;
    openFirewall = true;
    settings = {
      healthCheckTimeout = 60;
      models = {
        "glm-4.5-air-q4km" = {
          cmd = "${llama-server} --port \${PORT} -m /etc/llama-models/GLM-4.5-Air-Q4_K_M-00001-of-00002.gguf -ngl 20 --no-webui";
          aliases = [ "glm-4.5-air" ];
        };
      };
    };
  };

  environment.systemPackages = [
    llama-cpp
    pkgs.llama-swap
  ];
}
