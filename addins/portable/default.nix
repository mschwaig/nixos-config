{ config, pkgs, ... }:

{
  imports =
    [
      ./printers.nix
      #./wireguard3.nix
    ];
}
