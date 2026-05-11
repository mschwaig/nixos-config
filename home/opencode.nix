{ config, pkgs, lib, ... }:

let
  modelData = import ../addins/llm/models.nix { inherit pkgs lib; };

  hostname = "hive.van-duck.ts.net";
  shortHostname = builtins.head (lib.splitString "." hostname);

  expandSize = familyName: family: sizeKey: size:
    let
      context = size.context or family.context;
      opencodeF = family.opencode or {};
      opencodeS = size.opencode or {};
      output = opencodeS.maxOutput or opencodeF.maxOutput or (context / 2);

      makeEntry = modeSuffix: modeName:
        let
          key = "${familyName}-${sizeKey}${modeSuffix}";
          name = if family ? modes
            then "${familyName} ${sizeKey} (${modeName})"
            else "${familyName} ${sizeKey}";
        in {
          ${key} = {
            inherit name;
            limit = { inherit context output; };
          };
        };
    in
    if family ? modes then
      builtins.foldl' (acc: modeSuffix:
        acc // makeEntry modeSuffix (family.modes.${modeSuffix}.name or modeSuffix)
      ) {} (builtins.attrNames family.modes)
    else
      makeEntry "" "";

  allModels = builtins.foldl' (acc: entry:
    acc // expandSize entry.familyName entry.family entry.sizeKey entry.size
  ) {} (lib.concatMap (entry:
    let
      familyName = entry.familyName;
      family = entry.family;
    in
    map (sizeKey: {
      inherit familyName family sizeKey;
      size = family.sizes.${sizeKey};
    }) (builtins.attrNames family.sizes)
  ) (lib.mapAttrsToList (familyName: family: { inherit familyName family; }) modelData.families));

in
{
  home.file.".config/opencode/opencode.json" = {
    text = builtins.toJSON {
      "$schema" = "https://opencode.ai/config.json";
      small_model = "llama-swap-unauthed/qwen3.5-4b-fast";
      provider = {
        llama-swap-unauthed = {
          name = "llama-swap unauthed (${shortHostname})";
          npm = "@ai-sdk/openai-compatible";
          options.baseURL = "http://${hostname}:11434/v1";
          models = allModels;
        };
        llama-swap-authed = {
          name = "llama-swap authed (${shortHostname})";
          npm = "@ai-sdk/openai-compatible";
          options.baseURL = "https://${hostname}/v1";
          models = allModels;
        };
      };
    };
  };
}