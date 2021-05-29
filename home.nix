{ pkgs, ... }:
{
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "${pkgs.kitty}/bin/kitty";
      input = {
        "type:keyboard" = {
          #type = "keyboard";
          xkb_layout = "us-intl-german-umlaut";
        };
        "type:mouse" = {
          #type = "mouse";
          accel_profile = "flat";
        };
        "type:touchpad" = {
          #type = "touchpad";
          dwt = "enabled";
          tap = "disabled";
          natural_scroll = "enabled";
          accel_profile = "adaptive";
        };
      };
      output = {
        DP-3 = {
          bg = "~/.config/sway/background_2screen-1-0.jpg fill";
        };
        DP-4 = {
          bg = "~/.config/sway/background_2screen-1-0.jpg fill";
        };
      };
      bars = [{
        position = "top";
        statusCommand = "${pkgs.i3pystatus}/bin/i3pystatus -c /home/mschwaig/.config/i3pystatus/config.py";
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
    };
    wrapperFeatures.gtk = true;

    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
      export XDG_CURRENT_DESKTOP="sway"
    '';
  };

  services.kanshi = {
    enable = true;
    profiles = {
      hydralisk-home-dell = {
        outputs = [
          {
            criteria = "Dell Inc. DELL U2412M 0FFXD35335TS";
            status = "enable";
            mode = "1920x1200";
            position = "0,0";
          }
          {
            criteria = "Dell Inc. DELL U2412M 0FFXD36A1KPS";
            status = "enable";
            mode = "1920x1200";
            position = "1920,0";
          }
        ];
      };
      mutalisk-home-dell = {
        outputs = [
          {
            criteria = "Dell Inc. DELL U2412M 0FFXD35335TS";
            status = "enable";
            mode = "1920x1200";
            position = "0,0";
          }
          {
            criteria = "Dell Inc. DELL U2412M 0FFXD36A1KPS";
            status = "enable";
            mode = "1920x1200";
            position = "1920,0";
          }
          {
            criteria = "Unknown 0x058B 0x00000000";
            status = "disable";
          }
        ];
      };
      mutalisk-solo = {
        outputs = [
          {
            # TODO: set subpixl hinting?
            # exec sway output eDP-1 subpixel vrgb
            criteria = "Unknown 0x058B 0x00000000";
            status = "enable";
            mode = "2560x1440";
            position = "0,0";
            scale = 2.0;
          }
        ];
      };
      jku-streaming = {
        outputs = [
          {
            criteria = "Unknown HD60 S+ 0x00000000";
            status = "enable";
            mode = "1920x1080";
            position = "0,0";
          }
          {
            criteria = "Unknown 0x058B 0x00000000";
            status = "enable";
            mode = "2560x1440";
            position = "0,1080";
            scale = 2.0;
          }
          {
            criteria = "Unknown 0x058B 0x00000000";
            status = "disable";
          }
        ];
      };
      jku-workplace = {
        outputs = [
          {
            criteria = "Acer Technologies B276HUL T59EE0018501";
            status = "enable";
            mode = "2560x1440";
            position = "2560,0";
          }
          {
            criteria = "DP-4";
            status = "enable";
            mode = "2560x1440";
            position = "0,0";
          }
          {
            criteria = "Unknown 0x058B 0x00000000";
            status = "disable";
          }
        ];
      };
      jku-workplace-2 = {
        outputs = [
          {
            criteria = "Acer Technologies B276HUL T59EE0018501";
            status = "enable";
            mode = "2560x1440";
            position = "2560,0";
          }
          {
            criteria = "DP-6";
            status = "enable";
            mode = "2560x1440";
            position = "0,0";
          }
          {
            criteria = "Unknown 0x058B 0x00000000";
            status = "disable";
          } # TODO: enalbe onboard screen again
            # (disabled because after locking the screen
            # I cannot turn this on one again)
        ];
      };
    };
  };


  home.packages = with pkgs; [
    kitty
    #dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
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
    brightnessctl
    (python38.withPackages(ps: with ps; [ i3pystatus keyring ]))
  ];

  #xsession.enable = true;
  #xsession.windowManager.command = "…";
}
