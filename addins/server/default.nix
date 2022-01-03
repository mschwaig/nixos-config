{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../encrypted-zfs-root
      ../common.nix
    ];

    nix = {
      binaryCaches = [ "http://lair.lan/" ];
      binaryCachePublicKeys = [ "lair.lan:6RWQD3CFGg9OY4bhqPzBumZ+o70lIEVH3R9bxTj+FXw=" ];
      # See: https://discourse.nixos.org/t/using-experimental-nix-features-in-nixos-and-when-they-will-land-in-stable/7401/4 which gives the reason for the optional thing
      extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes) ''
        experimental-features = nix-command flakes ca-derivations ca-derivations
      '';
  };


  # disable sudo passwords to work around deploy-rs bug
  # See: https://github.com/serokell/deploy-rs/issues/78
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    htop screen unison smartmontools tmux git
  ];
}
