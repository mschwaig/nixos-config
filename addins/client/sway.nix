{ config, pkgs, lib, ... }:

{
  # This sway config is mostly based on https://nixos.wiki/wiki/Sway
  # which integrates sway with systemd in the style described here
  # https://github.com/swaywm/sway/wiki/Systemd-integration
  # and the replies in https://github.com/NixOS/nixpkgs/issues/57602
  # with some individual packages added/removed and using gdm as the display manager.
  #
  # Take care to start the correct target as described by the sway proejct wiki.
  # I do this by adding the following line to the bottom of my sway config file:
  # exec "systemctl --user import-environment; systemctl --user start sway-session.target"
  #
  # Remaining issues:
  #
  # The kanshi service configured here is quite broken for me.
  # When I add/remove outputs at runtime (via thunderbolt docks) kanshi often fails to
  # * correctly re-enable screens when docking/undocking even though it logs that it did it OR
  # * react to react to changes to the monitor configuration at all.
  # Oher than that everything seems to work fine AFAICT.

  # configuring sway itself (assmung a display manager starts it)
  systemd.user.targets.sway-session = {
    description = "Sway compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      dmenu
      swaylock
      swayidle
      xwayland
      mako
      kanshi
      grim
      slurp
      wl-clipboard
      wf-recorder
    ];
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
    '';
  };

  # configuring kanshi
  systemd.user.services.kanshi = {
    description = "Kanshi output autoconfig ";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    environment = { XDG_CONFIG_HOME="/home/mschwaig/.config"; };
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

  # configuring gdm
  # copied from https://github.com/NixOS/nixpkgs/issues/57602#issuecomment-657762138
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

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
}

