{ config, pkgs, lib, ... }:

{
  # The global sway option is needed for swaylock to actully unlock when given a correct password.
  # See: https://github.com/nix-community/home-manager/issues/1288
  programs.sway.enable = true;

  # TODO: verify the following is needed/working with sway configured via home-manager

  # for firefox screensharing
  # See: https://nixos.wiki/wiki/Firefox
  #xdg = {
  #  portal = {
  #    enable = true;
  #    extraPortals = with pkgs; [
  #      xdg-desktop-portal-wlr
  #      xdg-desktop-portal-gtk
  #    ];
  #    gtkUsePortal = true;
  #  };
  #};
  #services.pipewire.enable = true;
  users.users.mschwaig.extraGroups = [ "video" ];
}

