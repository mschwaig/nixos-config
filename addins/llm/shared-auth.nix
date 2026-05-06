{ config, pkgs, ... }:
let
  manage = pkgs.writeScriptBin "llm-auth-manage" (
    builtins.readFile ./llm-auth-manage.py
  );
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
    virtualHosts."hive.van-duck.ts.net".extraConfig = ''
      forward_auth 127.0.0.1:4180 {
        uri /auth
        copy_headers Authorization X-Auth-User
      }
      header_up -Authorization
      reverse_proxy 127.0.0.1:11435
    '';
  };

  services.tailscale.permitCertUid = "caddy";
}
