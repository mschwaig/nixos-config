# Based on the llama-swap NixOS module from nixpkgs:
#   https://github.com/NixOS/nixpkgs/blob/0c88e1f2bdb93d5999019e99cb0e61e1fe2af4c5/nixos/modules/services/networking/llama-swap.nix
# Extended with multi-instance support.
#
# SPDX-License-Identifier: MIT
{
  config,
  lib,
  pkgs,
  ...
}:
{
  disabledModules = [ "services/networking/llama-swap.nix" ];
}
// (
let
  cfg = config.services.llama-swap;
  settingsFormat = pkgs.formats.yaml { };

  commonServiceConfig = {
    Type = "exec";
    Restart = "on-failure";
    RestartSec = 3;

    # for GPU acceleration
    PrivateDevices = false;

    # hardening
    DynamicUser = true;
    CapabilityBoundingSet = "";
    RestrictAddressFamilies = [
      "AF_INET"
      "AF_INET6"
      "AF_UNIX"
    ];
    NoNewPrivileges = true;
    PrivateMounts = true;
    PrivateTmp = true;
    PrivateUsers = true;
    ProtectClock = true;
    ProtectControlGroups = true;
    ProtectHome = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectSystem = "strict";
    MemoryDenyWriteExecute = true;
    LockPersonality = true;
    RemoveIPC = true;
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      "~@privileged"
    ];
    SystemCallErrorNumber = "EPERM";
    ProtectProc = "invisible";
    ProtectHostname = true;
    ProcSubset = "pid";
    WorkingDirectory = "/tmp";
  };

  mkService =
    name: instanceCfg:
    let
      configFile = settingsFormat.generate "${name}.yaml" instanceCfg.settings;
    in
    {
      description = "Model swapping for LLaMA C++ Server (or any local OpenAPI compatible server)";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = commonServiceConfig // {
        ExecStart = "${lib.getExe cfg.package} ${
          lib.escapeShellArgs (
            [
              "--listen=${instanceCfg.listenAddress}:${toString instanceCfg.port}"
              "--config=${configFile}"
            ]
            ++ lib.optionals instanceCfg.tls.enable [
              "--tls-cert-file=${instanceCfg.tls.certFile}"
              "--tls-key-file=${instanceCfg.tls.keyFile}"
            ]
          )
        }";
      };
    };

  instanceSubmodule =
    { name, ... }:
    {
      options = {
        enable = lib.mkEnableOption "llama-swap instance ${name}";

        listenAddress = lib.mkOption {
          type = lib.types.str;
          default = "localhost";
          example = "0.0.0.0";
          description = ''
            Address that this llama-swap instance listens on.
          '';
        };

        port = lib.mkOption {
          default = 8080;
          example = 11343;
          type = lib.types.port;
          description = ''
            Port that this llama-swap instance listens on.
          '';
        };

        openFirewall = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether to open the firewall for this llama-swap instance.
            This adds {option}`port` to [](#opt-networking.firewall.allowedTCPPorts).
          '';
        };

        tls = {
          enable = lib.mkEnableOption "TLS encryption";

          certFile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            example = "/path/to/cert.pem";
            description = ''
              Path to the TLS certificate file. This certificate will be offered to,
              and may be verified by, clients.
            '';
          };

          keyFile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            example = "/path/to/key.pem";
            description = ''
              Path to the TLS private key file. This key will be used to decrypt,
              data received from clients.
            '';
          };
        };

        settings = lib.mkOption {
          type = lib.types.submodule { freeformType = settingsFormat.type; };
          default = { };
          description = ''
            llama-swap configuration. Refer to the [llama-swap example configuration](https://github.com/mostlygeek/llama-swap/blob/main/config.example.yaml)
            for details on supported values.
          '';
        };
      };
    };

  enabledInstances = lib.filterAttrs (_: instance: instance.enable) cfg.instances;
in
{
  options.services.llama-swap = {
    enable = lib.mkEnableOption "the llama-swap service";

    package = lib.mkPackageOption pkgs "llama-swap" { };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      example = "0.0.0.0";
      description = ''
        Address that llama-swap listens on.
      '';
    };

    port = lib.mkOption {
      default = 8080;
      example = 11343;
      type = lib.types.port;
      description = ''
        Port that llama-swap listens on.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open the firewall for llama-swap.
        This adds {option}`port` to [](#opt-networking.firewall.allowedTCPPorts).
      '';
    };

    tls = {
      enable = lib.mkEnableOption "TLS encryption";

      certFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/path/to/cert.pem";
        description = ''
          Path to the TLS certificate file. This certificate will be offered to,
          and may be verified by, clients.
        '';
      };

      keyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/path/to/key.pem";
        description = ''
          Path to the TLS private key file. This key will be used to decrypt,
          data received from clients.
        '';
      };
    };

    settings = lib.mkOption {
      type = lib.types.submodule { freeformType = settingsFormat.type; };
      default = { };
      description = ''
        llama-swap configuration. Refer to the [llama-swap example configuration](https://github.com/mostlygeek/llama-swap/blob/main/config.example.yaml)
        for details on supported values.
      '';
      example = lib.literalExpression ''
        let
          llama-cpp = pkgs.llama-cpp.override { rocmSupport = true; };
          llama-server = lib.getExe' llama-cpp "llama-server";
        in
        {
          healthCheckTimeout = 60;
          models = {
            "some-model" = {
              cmd = "''${llama-server} --port ''${PORT} -m /var/lib/llama-cpp/models/some-model.gguf -ngl 0 --no-webui";
              aliases = [
                "the-best"
              ];
            };
            "other-model" = {
              proxy = "http://127.0.0.1:5555";
              cmd = "''${llama-server} --port 5555 -m /var/lib/llama-cpp/models/other-model.gguf -ngl 0 -c 4096 -np 4 --no-webui";
              concurrencyLimit = 4;
            };
          };
        };
      '';
    };

    instances = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule instanceSubmodule);
      default = { };
      description = ''
        Attribute set of llama-swap instances. Use this when you need multiple
        llama-swap services with different configurations.
        Each instance generates a `llama-swap-<name>` systemd service.
      '';
    };
  };

  config = lib.mkMerge [
    # Legacy single-instance configuration
    (lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.tls.enable -> cfg.tls.certFile != null;
          message = "Please provide a certificate to use for TLS encryption.";
        }
        {
          assertion = cfg.tls.enable -> cfg.tls.keyFile != null;
          message = "Please provide a private key to use for TLS encryption.";
        }
      ];

      systemd.services.llama-swap = mkService "llama-swap" {
        listenAddress = cfg.listenAddress;
        port = cfg.port;
        tls = cfg.tls;
        settings = cfg.settings;
      };

      networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
    })

    # Multi-instance configuration
    (lib.mkIf (enabledInstances != { }) {
      assertions = lib.concatLists (
        lib.mapAttrsToList (
          name: instanceCfg:
          [
            {
              assertion = instanceCfg.tls.enable -> instanceCfg.tls.certFile != null;
              message = "Please provide a certificate to use for TLS encryption for llama-swap instance ${name}.";
            }
            {
              assertion = instanceCfg.tls.enable -> instanceCfg.tls.keyFile != null;
              message = "Please provide a private key to use for TLS encryption for llama-swap instance ${name}.";
            }
          ]
        ) enabledInstances
      );

      systemd.services = lib.mapAttrs' (
        name: instanceCfg:
        lib.nameValuePair "llama-swap-${name}" (mkService "llama-swap-${name}" {
          listenAddress = instanceCfg.listenAddress;
          port = instanceCfg.port;
          tls = instanceCfg.tls;
          settings = instanceCfg.settings;
        })
      ) enabledInstances;

      networking.firewall.allowedTCPPorts = lib.concatLists (
        lib.mapAttrsToList (_: instance: lib.optionals instance.openFirewall [ instance.port ]) (
          lib.filterAttrs (_: instance: instance.enable && instance.openFirewall) cfg.instances
        )
      );
    })
  ];

  meta.maintainers = with lib.maintainers; [
    jk
    podium868909
  ];
})
