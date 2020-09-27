{ config, pkgs, ... }:

{
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      dmenu
      # sddm
      swaylock
      swayidle
      xwayland
      waybar
      mako
      kanshi
      grim slurp wl-clipboard wf-recorder
    ];
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
    '';
  };

  systemd.defaultUnit = "graphical.target";
  systemd.services.sway = let sway = {
      tty = "7";
      username = "mschwaig";
    }; in  {
    enable = true;

    #description = "";
    #documentation =  "";
    environment.PATH = pkgs.lib.mkForce null;

    wants = [ "systemd-machined.service" ];
    aliases = [ "display-manager.service" ];
    after =  [
      "rc-local.service"
      "systemd-machined.service"
      "systemd-user-sessions.service"
      "systemd-logind.service"
      "plymouth-quit.service"
      "plymouth-start.service"
    ];
    serviceConfig = {
      ExecStartPre = "${config.system.path}/bin/chvt ${sway.tty}";
      ExecStart = "${pkgs.dbus}/bin/dbus-launch --exit-with-session ${pkgs.sway}/bin/sway --my-next-gpu-wont-be-nvidia";
      TTYPath = "/dev/tty${sway.tty}";
      TTYReset = "yes";
      TTYVHangup = "yes";
      TTYVTDisallocate = "yes";
      PAMName = "login";
      User = sway.username;
      WorkingDirectory = "/home/${sway.username}";
      StandardInput = "tty";
      StandardError = "journal";
      StandardOutput = "journal";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  programs.waybar.enable = true;

  systemd.user.services.kanshi = {
    description = "Kanshi output autoconfig ";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      # kanshi doesn't have an option to specifiy config file yet, so it looks
      # at .config/kanshi/config
      ExecStart = ''
      ${pkgs.kanshi}/bin/kanshi
      '';
      RestartSec = 5;
      Restart = "always";
    };
  };
}
