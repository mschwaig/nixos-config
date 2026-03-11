{ config, inputs, pkgs, lib, ... }:
let
  llama-cpp = pkgs.llama-cpp-rocm;
  llama-server = lib.getExe' llama-cpp "llama-server";
  models = import ./models.nix { inherit pkgs; };
  modelPath = name: "/etc/llama-models/${name}" + (if models ? ${name} then "" else throw "Model ${name} not found in models.nix");
in
{
  environment.etc = lib.mapAttrs' (name: value: 
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
        "gemma-3-27b" = {
          cmd = "${llama-server} --port \${PORT} -m ${modelPath "gemma-3-27b-it-qat-Q4_0.gguf"} --mmproj ${modelPath "mmproj-model-f16-27B.gguf"} -ngl 999 --no-webui";
        };
        "qwen3-30b-a3b" = {
          cmd = "${llama-server} --port \${PORT} --jinja -m ${modelPath "qwen3-30b-a3b-instruct-2507-q8_0.gguf"} -ngl 999 -c 65536 --no-webui";
        };
        "qwen3-coder-30b-a3b" = {
          cmd = "${llama-server} --port \${PORT} --jinja -m ${modelPath "qwen3-coder-30b-a3b-instruct-q8_0.gguf"} -ngl 999 -c 262144 --no-webui";
        };
        "gemma-3-12b" = {
          cmd = "${llama-server} --port \${PORT} -m ${modelPath "gemma-3-12b-it-qat-Q4_0.gguf"} --mmproj ${modelPath "mmproj-model-f16-12B.gguf"} -ngl 999 --no-webui";
        };
        "gpt-oss-20b" = {
          cmd = "${llama-server} --port \${PORT} -m ${modelPath "gpt-oss-20b-mxfp4.gguf"} --jinja --reasoning-format auto -ngl 999 -c 32768 --no-webui";
        };
        "gpt-oss-120b" = {
          cmd = "${llama-server} --port \${PORT} -m ${modelPath "gpt-oss-120b-mxfp4-00001-of-00003.gguf"} --jinja --reasoning-format auto -ngl 999 -c 32768 --no-webui";
        };

        # Qwen3.5 models - thinking mode (reasoning enabled)
        "qwen3.5-9b" = {
          # 9B has thinking disabled by default, explicitly enable it
          cmd = "${llama-server} --port \${PORT} --jinja -m ${modelPath "Qwen3.5-9B-UD-Q4_K_XL.gguf"} -ngl 999 -c 65536 --chat-template-kwargs '{\"enable_thinking\":true}' --no-webui";
        };
        "qwen3.5-27b" = {
          cmd = "${llama-server} --port \${PORT} --jinja -m ${modelPath "Qwen3.5-27B-UD-Q4_K_XL.gguf"} -ngl 999 -c 65536 --no-webui";
        };
        "qwen3.5-35b-a3b" = {
          cmd = "${llama-server} --port \${PORT} --jinja -m ${modelPath "Qwen3.5-35B-A3B-UD-Q4_K_XL.gguf"} -ngl 999 -c 65536 --no-webui";
        };
        "qwen3.5-122b-a10b" = {
          cmd = "${llama-server} --port \${PORT} --jinja -m ${modelPath "Qwen3.5-122B-A10B-UD-Q4_K_XL-00001-of-00003.gguf"} -ngl 999 -c 65536 --no-webui";
        };

        # Qwen3.5 models - non-thinking mode (faster, no reasoning overhead)
        "qwen3.5-9b-fast" = {
          cmd = "${llama-server} --port \${PORT} --jinja -m ${modelPath "Qwen3.5-9B-UD-Q4_K_XL.gguf"} -ngl 999 -c 65536 --chat-template-kwargs '{\"enable_thinking\":false}' --no-webui";
        };
        "qwen3.5-27b-fast" = {
          cmd = "${llama-server} --port \${PORT} --jinja -m ${modelPath "Qwen3.5-27B-UD-Q4_K_XL.gguf"} -ngl 999 -c 65536 --chat-template-kwargs '{\"enable_thinking\":false}' --no-webui";
        };
        "qwen3.5-35b-a3b-fast" = {
          cmd = "${llama-server} --port \${PORT} --jinja -m ${modelPath "Qwen3.5-35B-A3B-UD-Q4_K_XL.gguf"} -ngl 999 -c 65536 --chat-template-kwargs '{\"enable_thinking\":false}' --no-webui";
        };
        "qwen3.5-122b-a10b-fast" = {
          cmd = "${llama-server} --port \${PORT} --jinja -m ${modelPath "Qwen3.5-122B-A10B-UD-Q4_K_XL-00001-of-00003.gguf"} -ngl 999 -c 65536 --chat-template-kwargs '{\"enable_thinking\":false}' --no-webui";
        };
      };
    };
  };

  environment.systemPackages = [
    llama-cpp
    pkgs.llama-swap
  ];
}
