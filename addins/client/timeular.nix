{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ timeular bluezFull ];
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
