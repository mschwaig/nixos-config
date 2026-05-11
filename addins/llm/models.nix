{ pkgs, lib }:
let
  fetchGguf = import ./fetch-gguf.nix { inherit pkgs lib; };
in
{
  families = {
    "gemma-3" = {
      args = "";
      sizes = {
        "27b" = {
          context = 32768;
          gguf = fetchGguf {
            url = "https://huggingface.co/ggml-org/gemma-3-27b-it-qat-GGUF/resolve/main/gemma-3-27b-it-qat-Q4_0.gguf";
            hash = "sha256-VI2BbDGJ282v9mPqAk+2djHlYZRf/OsGYJPT1SJ3MBA=";
          };
          mmproj = fetchGguf {
            url = "https://huggingface.co/ggml-org/gemma-3-27b-it-qat-GGUF/resolve/main/mmproj-model-f16-27B.gguf";
            hash = "sha256-+tQ3uBtvYH0sJ0q8d/W2QaptGQ3a/mmPnEF5gdiFNqo=";
          };
        };
        "12b" = {
          context = 32768;
          gguf = fetchGguf {
            url = "https://huggingface.co/ggml-org/gemma-3-12b-it-qat-GGUF/resolve/main/gemma-3-12b-it-qat-Q4_0.gguf";
            hash = "sha256-f//uAOduS3Xcb5rMpDuZHRgfK5SDMHVkk4/Us5Gq02Q=";
          };
          mmproj = fetchGguf {
            url = "https://huggingface.co/ggml-org/gemma-3-12b-it-qat-GGUF/resolve/main/mmproj-model-f16-12B.gguf";
            hash = "sha256-n60lgU9IZavgD2dc+PePFlcvHXlGEnLu3gNF6728M1w=";
          };
        };
      };
    };

    "qwen3" = {
      args = "--jinja";
      sizes = {
        "30b-a3b" = {
          context = 65536;
          gguf = fetchGguf {
            url = "https://huggingface.co/ggml-org/Qwen3-30B-A3B-Instruct-2507-Q8_0-GGUF/resolve/main/qwen3-30b-a3b-instruct-2507-q8_0.gguf";
            hash = "sha256-Zsv8diRijKRyWmoFgblfIVWqaqBzpu1P+NFYeU7o/uM=";
          };
        };
        "coder-30b-a3b" = {
          context = 262144;
          gguf = fetchGguf {
            url = "https://huggingface.co/ggml-org/Qwen3-Coder-30B-A3B-Instruct-Q8_0-GGUF/resolve/main/qwen3-coder-30b-a3b-instruct-q8_0.gguf";
            hash = "sha256-8imT4pMYtbnsICb2tlgCpcqZs4q0hEqrg67YomzgD/Y=";
          };
        };
      };
    };

    "gpt-oss" = {
      args = "--jinja --reasoning-format auto";
      sizes = {
        "20b" = {
          context = 131072;
          gguf = fetchGguf {
            url = "https://huggingface.co/ggml-org/gpt-oss-20b-GGUF/resolve/main/gpt-oss-20b-mxfp4.gguf";
            hash = "sha256-vjemNqyg/BquDTIyX4L2tNIUlfBoI7X7wYmK4DA+mTU=";
          };
        };
        "120b" = {
          context = 131072;
          gguf = fetchGguf {
            url = "https://huggingface.co/ggml-org/gpt-oss-120b-GGUF/resolve/main/gpt-oss-120b-mxfp4-00001-of-00003.gguf";
            hashes = [
              "sha256-4oZetsHfey/76/MFzV2QdNXMwP47hi+Y00Okba0WBvk="
              "sha256-NGSS9liR+yfKxcdKjAdibL/rQhHNOR7E3jfbvjEJqTs="
              "sha256-ZtyoEECTP1pJF36CxHnFExnO+4O9ItrZ8G2tReJfFGM="
            ];
          };
        };
      };
    };

    "qwen3.5" = {
      context = 262144;
      args = "--jinja --no-mmap";
      modes = {
        "" = {
          name = "thinking";
          args = "--temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.0 --chat-template-kwargs '{\"enable_thinking\":true}'";
        };
        "-fast" = {
          name = "fast";
          args = "--temp 0.7 --top-p 0.8 --top-k 20 --min-p 0.0 --chat-template-kwargs '{\"enable_thinking\":false}'";
        };
      };
      sizes = {
        "0.8b" = {
          gguf = fetchGguf {
            url = "https://huggingface.co/unsloth/Qwen3.5-0.8B-GGUF/resolve/main/Qwen3.5-0.8B-UD-Q4_K_XL.gguf";
            hash = "sha256-MXfr1nr+RDg3TaGeaQvBuYdW9+D+qSQOG+QEM2FWp7U=";
          };
        };
        "2b" = {
          gguf = fetchGguf {
            url = "https://huggingface.co/unsloth/Qwen3.5-2B-GGUF/resolve/main/Qwen3.5-2B-UD-Q4_K_XL.gguf";
            hash = "sha256-CvlhZephW+o5oEEY1j8LbTWQiuqFDuSlGqYVHYUbizU=";
          };
        };
        "4b" = {
          gguf = fetchGguf {
            url = "https://huggingface.co/unsloth/Qwen3.5-4B-GGUF/resolve/main/Qwen3.5-4B-UD-Q4_K_XL.gguf";
            hash = "sha256-slLFYQpCyoLSD+KhKBPp0Gnu2JKSkH4mx4PusLyWG8c=";
          };
        };
        "9b" = {
          gguf = fetchGguf {
            url = "https://huggingface.co/unsloth/Qwen3.5-9B-GGUF/resolve/main/Qwen3.5-9B-UD-Q4_K_XL.gguf";
            hash = "sha256-b10wZmwtiuFqMG5hbZU0Hc88xGgQ34TX5vWn0eTBspM=";
          };
        };
        "27b" = {
          gguf = fetchGguf {
            url = "https://huggingface.co/unsloth/Qwen3.5-27B-GGUF/resolve/main/Qwen3.5-27B-UD-Q4_K_XL.gguf";
            hash = "sha256-E8tiKDRImK+lDZY8Aq4NmRriUJTuqIN9uNDkUukcWIg=";
          };
        };
        "35b-a3b" = {
          gguf = fetchGguf {
            url = "https://huggingface.co/unsloth/Qwen3.5-35B-A3B-GGUF/resolve/main/Qwen3.5-35B-A3B-UD-Q4_K_XL.gguf";
            hash = "sha256-GwrGN9+gkru6J5OXfblIWkDE+LQt9f40LwB21htmroM=";
          };
        };
        "122b-a10b" = {
          gguf = fetchGguf {
            url = "https://huggingface.co/unsloth/Qwen3.5-122B-A10B-GGUF/resolve/main/UD-Q4_K_XL/Qwen3.5-122B-A10B-UD-Q4_K_XL-00001-of-00003.gguf";
            hashes = [
              "sha256-Rnyb2S6lGFOc91v1pfv7016aC0DXZsyqZ78SDhIEHfM="
              "sha256-7NvULUOw35+g75pYTgnpWkOWbvA6Eiq6C4epnUTZrZg="
              "sha256-EzAODwWeb6IaoPq94qVU+d7qNmwOVPJoBFdpshSyjJc="
            ];
          };
        };
      };
    };

    "qwen3.6" = {
      context = 262144;
      args = "--jinja --no-mmap";
      modes = {
        "" = {
          name = "thinking";
          args = "--temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.0 --chat-template-kwargs '{\"enable_thinking\":true}'";
        };
        "-fast" = {
          name = "fast";
          args = "--temp 0.7 --top-p 0.8 --top-k 20 --min-p 0.0 --chat-template-kwargs '{\"enable_thinking\":false}'";
        };
      };
      sizes = {
        "27b" = {
          gguf = fetchGguf {
            url = "https://huggingface.co/unsloth/Qwen3.6-27B-GGUF/resolve/main/Qwen3.6-27B-UD-Q4_K_XL.gguf";
            hash = "sha256-/2lB3tUls06xWUlnYsKd0Oxucdwxt01X512HGgPuwlk=";
          };
        };
        "35b-a3b" = {
          gguf = fetchGguf {
            url = "https://huggingface.co/unsloth/Qwen3.6-35B-A3B-GGUF/resolve/main/Qwen3.6-35B-A3B-UD-Q4_K_XL.gguf";
            hash = "sha256-cHpVqKQ5fs3kTeDEmdPmjBrR0kDR2mWCa0lJ0QQ/RFA=";
          };
        };
      };
    };
  };
}
