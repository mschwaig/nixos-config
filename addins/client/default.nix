{ config, pkgs, ... }:

{
  imports =
    [
      ./sync.nix
      ./sway.nix
      ./scarlett-audio.nix
      ./thunderbolt.nix
      ./steam.nix
    ];

  nixpkgs.config.allowUnfree = true;

  # allow things like intel wifi firmware
  hardware.enableRedistributableFirmware = true;
  
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useNetworkd = true;
  networking.wireless.iwd.enable = true;
  networking.nameservers = [ "fd71:b189:717d::1" "192.168.97.1"];

  boot.supportedFilesystems = ["ntfs"];

  # Configure network proxy if necessary
  # networking.proxy.default = "sword@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  environment.systemPackages = with pkgs; [
    # gui apps
    firefox-beta-bin thunderbird vlc gimp transmission-gtk libreoffice-fresh

    # tiling-friendly apps
    sxiv zathura

    # video editing TODO: ensure that mlt version matches the one used by kdenlive
    kdeApplications.kdenlive mlt

    # development tools
    zig valgrind gdb gnumake gcc

    # terminl emulator (move to sway file?)
    kitty

    # terminal apps
    file ffmpeg htop git lolcat vifm-full tree archivemount pwgen jq nix-index tmux reptyr astyle protonvpn-cli

    (neovim.override {
      vimAlias = true;
      configure = {
        packages.myPlugins = with pkgs.vimPlugins; {
          start = [ vim-lastplace vim-nix ale ctrlp vim-better-whitespace ];
          opt = [];
        };
      };
    })

    (python38.withPackages(ps: with ps; [ qrcode ]))

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

  # enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mschwaig = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    description = "Martin Schwaighofer";
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  programs.vim.defaultEditor = true;

  fonts.fonts = with pkgs; [
    cascadia-code
  ];
}
