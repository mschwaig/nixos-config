{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../encrypted-zfs-root
      ../common.nix
    ];

    nix = {
      settings = {
        substituters = [ "http://lair.mschwaig.github.beta.tailscale.net/" ];
        trusted-public-keys = [ "lair.mschwaig.github.beta.tailscale.net:6RWQD3CFGg9OY4bhqPzBumZ+o70lIEVH3R9bxTj+FXw=" ];
      };
      extraOptions = ''
        experimental-features = nix-command flakes ca-derivations
      '';
  };


  # disable sudo passwords to work around deploy-rs bug
  # See: https://github.com/serokell/deploy-rs/issues/78
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    htop screen unison smartmontools tmux git
  ];
}
