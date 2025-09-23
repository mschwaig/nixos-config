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
    hash = "sha256-VI2BbDGJ282v9mPqAk+2djHlYZRf/OsGYJPT1SJ3MBA=";
  };

  "mmproj-model-f16-27B.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/ggml-org/gemma-3-27b-it-qat-GGUF/resolve/main/mmproj-model-f16-27B.gguf";
    hash = "sha256-+tQ3uBtvYH0sJ0q8d/W2QaptGQ3a/mmPnEF5gdiFNqo=";
  };

  "qwen3-30b-a3b-instruct-2507-q8_0.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/ggml-org/Qwen3-30B-A3B-Instruct-2507-Q8_0-GGUF/resolve/main/qwen3-30b-a3b-instruct-2507-q8_0.gguf";
    hash = pkgs.lib.fakeHash;
  };

  "gemma-3-12b-it-qat-Q4_0.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/ggml-org/gemma-3-12b-it-qat-GGUF/resolve/main/gemma-3-12b-it-qat-Q4_0.gguf";
    hash = pkgs.lib.fakeHash;
  };

  "mmproj-model-f16-12B.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/ggml-org/gemma-3-12b-it-qat-GGUF/resolve/main/mmproj-model-f16-12B.gguf";
    hash = pkgs.lib.fakeHash;
  };

  "gpt-oss-20b-mxfp4.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/ggml-org/gpt-oss-20b-GGUF/resolve/main/gpt-oss-20b-mxfp4.gguf";
    hash = pkgs.lib.fakeHash;
  };

  "gpt-oss-120b-mxfp4-00001-of-00003.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/ggml-org/gpt-oss-120b-GGUF/resolve/main/gpt-oss-120b-mxfp4-00001-of-00003.gguf";
    hash = pkgs.lib.fakeHash;
  };

  "qwen3-coder-30b-a3b-instruct-q8_0.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/ggml-org/Qwen3-Coder-30B-A3B-Instruct-Q8_0-GGUF/resolve/main/qwen3-coder-30b-a3b-instruct-q8_0.gguf";
    hash = pkgs.lib.fakeHash;
  };
}
