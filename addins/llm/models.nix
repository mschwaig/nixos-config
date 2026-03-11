{ pkgs }:
{
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
    hash = "sha256-Zsv8diRijKRyWmoFgblfIVWqaqBzpu1P+NFYeU7o/uM=";
  };

  "gemma-3-12b-it-qat-Q4_0.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/ggml-org/gemma-3-12b-it-qat-GGUF/resolve/main/gemma-3-12b-it-qat-Q4_0.gguf";
    hash = "sha256-f//uAOduS3Xcb5rMpDuZHRgfK5SDMHVkk4/Us5Gq02Q=";
  };

  "mmproj-model-f16-12B.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/ggml-org/gemma-3-12b-it-qat-GGUF/resolve/main/mmproj-model-f16-12B.gguf";
    hash = "sha256-n60lgU9IZavgD2dc+PePFlcvHXlGEnLu3gNF6728M1w=";
  };

  "gpt-oss-20b-mxfp4.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/ggml-org/gpt-oss-20b-GGUF/resolve/main/gpt-oss-20b-mxfp4.gguf";
    hash = "sha256-vjemNqyg/BquDTIyX4L2tNIUlfBoI7X7wYmK4DA+mTU=";
  };

  "gpt-oss-120b-mxfp4-00001-of-00003.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/ggml-org/gpt-oss-120b-GGUF/resolve/main/gpt-oss-120b-mxfp4-00001-of-00003.gguf";
    hash = "sha256-4oZetsHfey/76/MFzV2QdNXMwP47hi+Y00Okba0WBvk=";
  };

  "gpt-oss-120b-mxfp4-00002-of-00003.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/ggml-org/gpt-oss-120b-GGUF/resolve/main/gpt-oss-120b-mxfp4-00002-of-00003.gguf";
    hash = "sha256-NGSS9liR+yfKxcdKjAdibL/rQhHNOR7E3jfbvjEJqTs=";
  };

  "gpt-oss-120b-mxfp4-00003-of-00003.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/ggml-org/gpt-oss-120b-GGUF/resolve/main/gpt-oss-120b-mxfp4-00003-of-00003.gguf";
    hash = "sha256-ZtyoEECTP1pJF36CxHnFExnO+4O9ItrZ8G2tReJfFGM=";
  };

  "qwen3-coder-30b-a3b-instruct-q8_0.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/ggml-org/Qwen3-Coder-30B-A3B-Instruct-Q8_0-GGUF/resolve/main/qwen3-coder-30b-a3b-instruct-q8_0.gguf";
    hash = "sha256-8imT4pMYtbnsICb2tlgCpcqZs4q0hEqrg67YomzgD/Y=";
  };

  # Qwen3.5 models
  "Qwen3.5-9B-UD-Q4_K_XL.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/unsloth/Qwen3.5-9B-GGUF/resolve/main/Qwen3.5-9B-UD-Q4_K_XL.gguf";
    hash = "sha256-b10wZmwtiuFqMG5hbZU0Hc88xGgQ34TX5vWn0eTBspM=";
  };

  "Qwen3.5-27B-UD-Q4_K_XL.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/unsloth/Qwen3.5-27B-GGUF/resolve/main/Qwen3.5-27B-UD-Q4_K_XL.gguf";
    hash = "sha256-E8tiKDRImK+lDZY8Aq4NmRriUJTuqIN9uNDkUukcWIg=";
  };

  "Qwen3.5-35B-A3B-UD-Q4_K_XL.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/unsloth/Qwen3.5-35B-A3B-GGUF/resolve/main/Qwen3.5-35B-A3B-UD-Q4_K_XL.gguf";
    hash = "sha256-GwrGN9+gkru6J5OXfblIWkDE+LQt9f40LwB21htmroM=";
  };

  "Qwen3.5-122B-A10B-UD-Q4_K_XL-00001-of-00003.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/unsloth/Qwen3.5-122B-A10B-GGUF/resolve/main/UD-Q4_K_XL/Qwen3.5-122B-A10B-UD-Q4_K_XL-00001-of-00003.gguf";
    hash = "sha256-Rnyb2S6lGFOc91v1pfv7016aC0DXZsyqZ78SDhIEHfM=";
  };

  "Qwen3.5-122B-A10B-UD-Q4_K_XL-00002-of-00003.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/unsloth/Qwen3.5-122B-A10B-GGUF/resolve/main/UD-Q4_K_XL/Qwen3.5-122B-A10B-UD-Q4_K_XL-00002-of-00003.gguf";
    hash = "sha256-7NvULUOw35+g75pYTgnpWkOWbvA6Eiq6C4epnUTZrZg=";
  };

  "Qwen3.5-122B-A10B-UD-Q4_K_XL-00003-of-00003.gguf" = pkgs.fetchurl {
    url = "https://huggingface.co/unsloth/Qwen3.5-122B-A10B-GGUF/resolve/main/UD-Q4_K_XL/Qwen3.5-122B-A10B-UD-Q4_K_XL-00003-of-00003.gguf";
    hash = "sha256-EzAODwWeb6IaoPq94qVU+d7qNmwOVPJoBFdpshSyjJc=";
  };
}
