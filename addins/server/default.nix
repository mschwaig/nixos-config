{ config, pkgs, ... }:

{
  imports =
    [
      ../encrypted-zfs-root
      ../common.nix
    ];

  # disable sudo passwords to work around deploy-rs bug
  # See: https://github.com/serokell/deploy-rs/issues/78
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    htop screen unison smartmontools tmux git
  ];
}
