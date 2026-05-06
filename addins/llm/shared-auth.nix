{ config, pkgs, ... }:
let
  manage = pkgs.writeShellScriptBin "llm-auth-manage" ''
    exec ${pkgs.python3}/bin/python3 ${./llm-auth-manage.py} "$@"
  '';
  sidecar = pkgs.writeScript "llm-auth-sidecar" (
    builtins.readFile ./llm-auth-sidecar.py
  );
in
{
  environment.systemPackages = [ manage ];

  users.users.llm-auth-sidecar = {
    isSystemUser = true;
    group = "llm-auth-sidecar";
  };
  users.groups.llm-auth-sidecar = { };

  systemd.services.llm-auth-sidecar = {
    description = "LLM Auth Sidecar";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "llm-auth-sidecar";
      Group = "llm-auth-sidecar";
      ExecStart = "${pkgs.python3}/bin/python3 ${sidecar}";
      Restart = "on-failure";
      RestartSec = 3;
      CapabilityBoundingSet = "";
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      ProtectHome = true;
      ProtectClock = true;
      MemoryDenyWriteExecute = true;
      LockPersonality = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "@system-service" "~@privileged" ];
      SystemCallErrorNumber = "EPERM";
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts.":1980".extraConfig = ''
      forward_auth 127.0.0.1:4180 {
        uri /auth
        copy_headers Authorization X-Auth-User
      }
      reverse_proxy 127.0.0.1:11435 {
        header_up -Authorization
      }
    '';
  };

  systemd.services.tailscale-funnel = {
    description = "Tailscale Funnel for shared LLM service";
    after = [ "tailscaled.service" "caddy.service" ];
    wants = [ "tailscaled.service" "caddy.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${config.services.tailscale.package}/bin/tailscale funnel --bg --set-path / http://127.0.0.1:1980";
      ExecStop = "${config.services.tailscale.package}/bin/tailscale funnel off";
    };
  };
}
