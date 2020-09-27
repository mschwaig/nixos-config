{ config, pkgs, ... }:

{
  imports =
    [
      ./sync.nix
      ./sway.nix
    ];

  nixpkgs.config.allowUnfree = true;

  # allow things like intel wifi firmware
  hardware.enableRedistributableFirmware = true;
  
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
}
