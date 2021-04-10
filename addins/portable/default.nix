{ config, pkgs, ... }:

{
  imports =
    [
      ./printers.nix
      ./wireguard.nix
    ];

    services.upower = {
      enable = true;
      percentageLow = 25;
      percentageCritical = 15;
      percentageAction = 10;
    };
}
