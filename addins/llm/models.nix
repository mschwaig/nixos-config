{ pkgs }:
{
  "GLM-4.5-Air-Q4_K_M-00001-of-00002.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/unsloth/GLM-4.5-Air-GGUF/resolve/main/Q4_K_M/GLM-4.5-Air-Q4_K_M-00001-of-00002.gguf";
    hash = "sha256-vE8oKY+wX/mLdpJfbBQ+cRp/stXOtO1LfB9luMhLm5s=";
  };

  "GLM-4.5-Air-Q4_K_M-00002-of-00002.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/unsloth/GLM-4.5-Air-GGUF/resolve/main/Q4_K_M/GLM-4.5-Air-Q4_K_M-00002-of-00002.gguf";
    hash = "sha256-WBJE206BmJQ8C4CcgXMNaOJOCgqN5p5NoQH/pIIFXCc=";
  };

  "gemma-3-27b-it-qat-Q4_0.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/ggml-org/gemma-3-27b-it-qat-GGUF/resolve/main/gemma-3-27b-it-qat-Q4_0.gguf";
    hash = pkgs.lib.fakeHash;
  };

  "mmproj-model-f16-27B.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/ggml-org/gemma-3-27b-it-qat-GGUF/resolve/main/mmproj-model-f16-27B.gguf";
    hash = pkgs.lib.fakeHash;
  };
}