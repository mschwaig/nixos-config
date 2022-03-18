{ config, pkgs, lib, ... }:

{
  # The global sway option is needed for swaylock to actully unlock when given a correct password.
  # See: https://github.com/nix-community/home-manager/issues/1288
  programs.sway.enable = true;

  # for firefox screensharing
  # See: https://nixos.wiki/wiki/Firefox
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };
  };

  sound.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  users.users.mschwaig.extraGroups = [ "video" ];
}

