{ config, inputs, pkgs, lib, ... }:
with lib;
let
  mapAttrs = pkgs.lib.attrsets.mapAttrs;
in
{
  imports =
    [
      ./printers.nix
    ];

  config = {
    environment.systemPackages = with pkgs; [
      signal-desktop
    ];
    nix = {
      settings = {
        trusted-public-keys = [ "lair.van-duck.ts.net.net:6RWQD3CFGg9OY4bhqPzBumZ+o70lIEVH3R9bxTj+FXw=" ];
      };
    };

    networking.networkmanager.enable = true;
  };
}
