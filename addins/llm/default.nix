{ config, inputs, pkgs, lib, ... }:
let
  llama-cpp = pkgs.llama-cpp.override { vulkanSupport = true; };
  llama-server = lib.getExe' llama-cpp "llama-server";
  modelData = import ./models.nix { inherit pkgs lib; };

  llamaBase = "-ngl 999 --no-webui";

  collectGgufs = families:
    builtins.listToAttrs (lib.concatMap (family:
      lib.concatMap (size:
        [{ name = size.gguf.name; value = size.gguf.drv; }]
        ++ lib.optional (size ? mmproj) { name = size.mmproj.name; value = size.mmproj.drv; }
        ++ map (s: { name = s.name; value = s.drv; }) (size.gguf.shards or [])
      ) (builtins.attrValues family.sizes)
    ) (builtins.attrValues families));

  allGgufs = collectGgufs modelData.families;

  modelPath = name:
    "/etc/llama-models/${name}"
    + (if allGgufs ? ${name} then "" else throw "Model file ${name} not found");

  buildModelConfigs = families:
    builtins.listToAttrs (lib.concatMap (entry:
      let
        familyName = entry.familyName;
        family = entry.family;
      in
      lib.concatMap (sizeKey:
        let
          size = family.sizes.${sizeKey};
          context = toString (size.context or family.context);
          baseCmd = "${llama-server} --port \${PORT} -m ${modelPath size.gguf.name}"
            + lib.optionalString (size ? mmproj) " --mmproj ${modelPath size.mmproj.name}"
            + " ${family.args} -c ${context} ${llamaBase}";
        in
        if family ? modes then
          lib.mapAttrsToList (suffix: mode: {
            name = "${familyName}-${sizeKey}${suffix}";
            value = { cmd = "${baseCmd} ${mode.args}"; };
          }) family.modes
        else
          [{
            name = "${familyName}-${sizeKey}";
            value = { cmd = baseCmd; };
          }]
      ) (builtins.attrNames family.sizes)
    ) (lib.mapAttrsToList (familyName: family: { inherit familyName family; }) families));

  modelConfigs = buildModelConfigs modelData.families;
in
{
  imports = [
    ./llama-swap.nix
    ./shared-auth.nix
  ];

  environment.etc = lib.mapAttrs' (name: value:
    lib.nameValuePair "llama-models/${name}" { source = value; }
  ) allGgufs;

  services.llama-swap.instances = {
    private = {
      enable = true;
      port = 11434;
      listenAddress = "0.0.0.0";
      openFirewall = true;
      settings = {
        healthCheckTimeout = 60;
        models = modelConfigs;
      };
    };
    shared = {
      enable = true;
      port = 11435;
      listenAddress = "127.0.0.1";
      settings = {
        healthCheckTimeout = 60;
        peers = {
          private = {
            proxy = "http://127.0.0.1:11434";
            models = builtins.attrNames modelConfigs;
          };
        };
      };
    };
  };

  environment.systemPackages = [
    llama-cpp
    pkgs.llama-swap
  ];
}
