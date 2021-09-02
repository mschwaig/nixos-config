{ config, pkgs, ... }:

{
  imports =
    [
      ./printers.nix
      ./wireguard.nix
    ];

    networking.wireless.enable = true;

    services.upower = {
      enable = true;
      percentageLow = 25;
      percentageCritical = 15;
      percentageAction = 10;
    };
}
