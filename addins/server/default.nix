{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../encrypted-zfs-root
      ../common.nix
    ];

    nix = {
      settings = {
        substituters = [ "http://lair.van-duck.ts.net.net/" ];
        trusted-public-keys = [ "lair.van-duck.ts.net.net:6RWQD3CFGg9OY4bhqPzBumZ+o70lIEVH3R9bxTj+FXw=" ];
      };
      extraOptions = ''
        experimental-features = nix-command flakes ca-derivations
      '';
  };

  # retry connecting to the network
  # See: https://github.com/NixOS/nixpkgs/issues/41012
  boot.initrd.network.udhcpc.extraArgs = [ "--timeout 5 --tryagain 60 --background" ];

  # disable sudo passwords to work around deploy-rs bug
  # See: https://github.com/serokell/deploy-rs/issues/78
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    htop screen unison smartmontools tmux git
  ];
}
