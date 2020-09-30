{ config, pkgs, lib, ... }:

{
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  # see https://github.com/NixOS/nixpkgs/issues/57602#issuecomment-657762138
  # extracted from nixos/modules/services/x11/xserver.nix
  systemd.defaultUnit = "graphical.target";
  systemd.services.display-manager =
    let
      cfg = config.services.xserver.displayManager;
    in
    {
      description = "Display Manager";

      after = [ "acpid.service" "systemd-logind.service" ];

      restartIfChanged = false;

      environment =
        lib.optionalAttrs
          config.hardware.opengl.setLdLibraryPath {
          LD_LIBRARY_PATH = pkgs.addOpenGLRunpath.driverLink;
        } // cfg.job.environment;

      preStart =
        ''
          ${cfg.job.preStart}

          rm -f /tmp/.X0-lock
        '';

      script = "${cfg.job.execCmd}";

      serviceConfig = {
        Restart = "always";
        RestartSec = "200ms";
        SyslogIdentifier = "display-manager";
        # Stop restarting if the display manager stops (crashes) 2 times
        # in one minute. Starting X typically takes 3-4s.
        StartLimitInterval = "30s";
        StartLimitBurst = "3";
      };
    };

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

  programs.waybar.enable = true;
}
