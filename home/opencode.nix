{ pkgs, lib, ... }:

let
  inherit (lib) toUpper;

  modelsData = import ../addins/llm/models-data.nix;

  hostname = "hive.van-duck.ts.net";

  toDisplaySize = size: toUpper size;

  modes = {
    ""      = "thinking";
    "-fast" = "fast";
  };

  expandFamily = family: context: prefix: sizes:
    builtins.foldl' (acc: size:
      acc // builtins.foldl' (acc': suffix:
        let
          key = "${family}-${size}${suffix}";
        in
        acc' // {
          ${key} = {
            name = "${prefix} ${toDisplaySize size} (${modes.${suffix}})";
            limit = {
              inherit context;
              output = context / 2;
            };
          };
        }
      ) {} (builtins.attrNames modes)
    ) {} sizes;

  allModels = builtins.foldl' (acc: family:
    acc // expandFamily family.key family.context family.prefix family.sizes
  ) (lib.mapAttrs (name: m: {
    name = m.displayName;
    limit = {
      inherit (m) context;
      output = m.context / 2;
    };
  }) modelsData.individuals) (lib.mapAttrsToList (key: value: { inherit key; } // value) modelsData.families);

  mkProvider = port:
    let
      baseURL = if port == 443
        then "https://${hostname}/v1"
        else "http://${hostname}:${toString port}/v1";
    in
    {
      npm = "@ai-sdk/openai-compatible";
      options.baseURL = baseURL;
      models = allModels;
    };

in
{
  home.file.".config/opencode/opencode.json" = {
    text = builtins.toJSON {
      "$schema" = "https://opencode.ai/config.json";
      small_model = "llama-swap-unauthed/qwen3.5-4b-fast";
      provider = {
        llama-swap-unauthed = (mkProvider 11434) // { name = "llama-swap (${hostname})"; };
        llama-swap-authed   = (mkProvider 443)   // { name = "llama-swap authed (${hostname})"; };
      };
    };
  };
}
