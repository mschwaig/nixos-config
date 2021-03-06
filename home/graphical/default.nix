{ pkgs, ... }: {

  imports = [
    ./kanshi.nix
    ./kitty.nix
  ];

  services.swayidle = {
    enable = true;

    timeouts = [{
      timeout = 120;
      command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
    } {
      timeout = 240;
      command = ''${pkgs.sway}/bin/swaymsg "output * dpms off"'';
      resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * dpms on"'';
    }];

    events = [{
      event = "before-sleep";
      command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
    } {
      event = "lock";
      command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
    }];
  };

  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "${pkgs.kitty}/bin/kitty";
      menu = "${pkgs.fuzzel}/bin/fuzzel --font=\"Cascadia Code Semi Light\"";
      input = {
        "type:keyboard" = {
          xkb_layout = "us-intl-german-umlaut";
        };
        "type:mouse" = {
          accel_profile = "flat";
        };
        "type:touchpad" = {
          dwt = "enabled";
          tap = "disabled";
          natural_scroll = "enabled";
          accel_profile = "adaptive";
        };
      };
      output = {
        "*" = {
          bg = "~/.config/sway/nix-brown-4k.png fill";
        };
      };
      bars = [{
        position = "top";
        #statusCommand = "${pkgs.i3pystatus}/bin/i3pystatus -c /home/mschwaig/.config/i3pystatus/config.py";
        colors = {
          statusline = "#ffffff";
          background = "#323232";
          inactiveWorkspace = {
            background = "#32323200";
            border = "#32323200";
            text = "#5c5c5c";
          };
        };
      }];

      window.commands = [{
        criteria = { instance = "skype"; };
        command = "inhibit_idle visible";
      }{
        criteria = { app_id = "vinagre"; };
        command = "inhibit_idle visible";
      }];
    };
    wrapperFeatures.gtk = true;

    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland-egl
      export XDG_SESSION_TYPE=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway";
    # only for nvidia
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  home.packages = with pkgs; [
    (pkgs.writeShellApplication {
      name = "idle_stopper";
      # set inhibit idle on launch and
      # diable it again when exiting in any way
      # besides SIGKILL (-9)
      text = ''
        echo "stopping screens from going idle ..."
        reenable_idle() {
          ${pkgs.sway}/bin/swaymsg inhibit_idle none
        }

        ${pkgs.sway}/bin/swaymsg inhibit_idle open
        trap reenable_idle EXIT

        sleep infinity
      '';
    })
    kitty
    fuzzel
    swaylock
    swayidle
    xwayland
    mako
    kanshi
    grim
    slurp
    wl-clipboard
    wf-recorder
    brightnessctl
    (python38.withPackages(ps: with ps; [ i3pystatus keyring ]))
  ];
}
