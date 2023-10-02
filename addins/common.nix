{ config, pkgs, ... }:

{
  # allow things like intel wifi firmware
  hardware.enableRedistributableFirmware = true;
  # enable fwupd for manual firmware updates
  services.fwupd.enable = true;

  # TODO: switch back to latest when there is ZFS support for it
  boot.kernelPackages = pkgs.linuxPackages_5_15;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  services.tailscale.enable = true;

  #networking.useNetworkd = true;
  #systemd.services.systemd-networkd-wait-online.enable = false;

  # dhcp set per interface because global flag is deprecated
  networking.useDHCP = false;
  networking.nameservers = [ "fde4:c86b:cbd3:97::1" "8.8.8.8" ];

  time.timeZone = "Europe/Vienna";

  environment = {
    systemPackages = with pkgs; [
      helix

      # Android MTP
      jmtpfs

      # fuzzy search
      silver-searcher

      # monitoring
      lm_sensors acpi

      # display system properties
      neofetch

      # remote managment
      ethtool
    ];
    variables =
    let editor = "hx"; in {
      EDITOR = editor;
      VISUAL = editor;
    };
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  users.users.mschwaig = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    description = "Martin Schwaighofer";
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
}
