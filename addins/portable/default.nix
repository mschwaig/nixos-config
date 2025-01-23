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
        # substituters = [ "http://cache.nix.ins.jku.at" ];
        trusted-public-keys = [ "lair.van-duck.ts.net.net:6RWQD3CFGg9OY4bhqPzBumZ+o70lIEVH3R9bxTj+FXw=" "cache.nix.ins.jku.at:CPefhQ5WiLuI6Bc9T8sErWf0n5Jwu5Pl+i3B2tFg+/U=" ];
      };
    };

    networking.networkmanager.enable = true;
  };
}
