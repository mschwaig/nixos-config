{ config, pkgs, lib, log-keep-duration, ... }:
let
  log-keep-duration = "8w";
in {
  systemd = {

    services.delete-old-logs = {

      description = "Delete old logs.";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/journalctl --vacuum-time=${log-keep-duration}";
      };
    };

    timers.clear-log = {
      wantedBy = [ "timers.target" ];
      partOf = [ "delete-old-logs.service" ];
      timerConfig.OnCalendar = "weekly UTC";
    };
  };
}
