{ config, inputs, pkgs, system, ... }:

{
  imports = [
#    ./attest.nix
  ];

  # allow things like intel wifi firmware
  hardware.enableRedistributableFirmware = true;
  # enable fwupd for manual firmware updates
  services.fwupd.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
    memtest86.enable = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    extraUpFlags = [ "--accept-dns" ];
  };
  #networking.useNetworkd = true;

  # dhcp set per interface because global flag is deprecated
  networking.useDHCP = false;

  time.timeZone = "Europe/Vienna";

  environment = {
    systemPackages = with pkgs; [
      inputs.helix.packages.${pkgs.system}.default

      # Android MTP
      jmtpfs

      # monitoring
      lm_sensors acpi

      # display system properties
      neofetch

      # remote managment
      ethtool
    ];
    variables = {
      EDITOR = "hx";
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
