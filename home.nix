{ pkgs, ... }:
{
  wayland.windowManager.sway = {
    enable = true;
    #configFile = ~/config/sway/config;
  };

  home.packages = with pkgs; [
    alacritty # Alacritty is the default terminal in the config
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
