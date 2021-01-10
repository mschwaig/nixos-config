{ config, pkgs, ... }:

{
  imports =
    [
      ../encrypted-zfs-root
      ../common.nix
    ];

  environment.systemPackages = with pkgs; [
    htop screen unison smartmontools tmux git
  ];
}
