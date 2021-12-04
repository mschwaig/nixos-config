{ pkgs, ... }: {

  imports = [
    ./kanshi.nix
    ./kitty.nix
  ];

  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "${pkgs.kitty}/bin/kitty";
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
      export QT_QPA_PLATFORM=wayland-egl
      export XDG_SESSION_TYPE=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway";
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
}
