{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ timeular bluezFull ];
}
