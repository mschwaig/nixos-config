{
  # Model families — shared context, multiple sizes + thinking/fast variants
  families = {
    "qwen3.5" = {
      context = 262144;
      prefix = "Qwen3.5";
      sizes = [ "0.8b" "2b" "4b" "9b" "27b" "35b-a3b" "122b-a10b" ];
    };
    "qwen3.6" = {
      context = 262144;
      prefix = "Qwen3.6";
      sizes = [ "27b" "35b-a3b" ];
    };
  };

  # Individual models with unique context
  individuals = {
    "gemma-3-27b" = {
      context = 32768;
      displayName = "Gemma 3 27B (vision)";
    };
    "gemma-3-12b" = {
      context = 32768;
      displayName = "Gemma 3 12B (vision)";
    };
    "qwen3-30b-a3b" = {
      context = 65536;
      displayName = "Qwen3 30B-A3B";
    };
    "qwen3-coder-30b-a3b" = {
      context = 262144;
      displayName = "Qwen3 Coder 30B-A3B";
    };
    "gpt-oss-20b" = {
      context = 131072;
      displayName = "GPT-OSS 20B";
    };
    "gpt-oss-120b" = {
      context = 131072;
      displayName = "GPT-OSS 120B";
    };
  };
}
