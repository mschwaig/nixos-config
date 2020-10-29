{ config, pkgs, ... }:

{
  imports =
    [
      ./printers.nix
      #./wireguard.nix
    ];
}
