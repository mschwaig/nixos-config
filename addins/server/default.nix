{ config, pkgs, ... }:

{
  imports =
    [
      ../encrypted-zfs-root
    ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
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
  #networking.wireless.iwd.enable = true;
  networking.nameservers = [ "fde4:c86b:cbd3:97::1" "192.168.97.1"];

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  environment.systemPackages = with pkgs; [
    htop screen unison smartmontools tmux git

    (neovim.override {
      vimAlias = true;
      configure = {
        packages.myPlugins = with pkgs.vimPlugins; {
          start = [ vim-lastplace vim-nix ale ctrlp vim-better-whitespace ];
          opt = [];
        };
      };
    })

    # monitoring
    lm_sensors acpi

    # remote managment
    ethtool
  ];

  # enable openssh deamon
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mschwaig = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    description = "Martin Schwaighofer";
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  programs.vim.defaultEditor = true;
}
