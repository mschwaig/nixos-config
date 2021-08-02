{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixFlakes;
    binaryCaches = [ "http://lair.lan/" ];
    binaryCachePublicKeys = [ "lair.lan:6RWQD3CFGg9OY4bhqPzBumZ+o70lIEVH3R9bxTj+FXw=" ];
    # See: https://discourse.nixos.org/t/using-experimental-nix-features-in-nixos-and-when-they-will-land-in-stable/7401/4 which gives the reason for the optional thing
    extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes) ''
      experimental-features = nix-command flakes
    '';
  };

  # allow things like intel wifi firmware
  hardware.enableRedistributableFirmware = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  #networking.useNetworkd = true;
  #systemd.services.systemd-networkd-wait-online.enable = false;

  # dhcp set per interface because global flag is deprecated
  networking.useDHCP = false;
  networking.nameservers = [ "fde4:c86b:cbd3:97::1" "192.168.97.1"];

  time.timeZone = "Europe/Vienna";

  environment.systemPackages = with pkgs; [
    (neovim.override {
      vimAlias = true;
      configure = {
        packages.myPlugins = with pkgs.vimPlugins; {
          start = [ vim-lastplace vim-nix ale ctrlp vim-better-whitespace fzf-vim ];
          opt = [];
        };
      };
    })

    # fuzzy search
    ag

    # monitoring
    lm_sensors acpi

    # remote managment
    ethtool
  ];

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  users.users.mschwaig = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    description = "Martin Schwaighofer";
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  programs.vim.defaultEditor = true;
}
