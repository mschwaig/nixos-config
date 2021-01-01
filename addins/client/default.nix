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
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useNetworkd = true;
  systemd.services.systemd-networkd-wait-online.enable = false;
  networking.wireless.iwd.enable = true;
  networking.nameservers = [ "fde4:c86b:cbd3:97::1" "192.168.97.1"];

  boot.supportedFilesystems = [ "ntfs" "fuse-7z-ng" ];

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
    firefox-beta-bin thunderbird vlc gimp transmission-gtk libreoffice-fresh chromium inkscape audacity

    discord

    # tiling-friendly apps
    sxiv zathura

    # video editing TODO: ensure that mlt version matches the one used by kdenlive
    kdeApplications.kdenlive

    mlt

    # development tools
    zig valgrind gdb gnumake gcc

    # terminl emulator (move to sway file?)
    kitty

    # terminal apps
    file ffmpeg htop bandwhich git lolcat vifm-full tree archivemount pwgen jq nix-index tmux reptyr astyle protonvpn-cli zip zstd tmate unzip tealdeer diffoscope xdelta wally-cli

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
    lm_sensors acpi pulsemixer wireshark

    # remote managment
    ethtool

    fuse-7z-ng
  ];

  # enable openssh deamon
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };

  programs.adb.enable = true;

  services.udev = {
    extraRules = ''
      # STM32 rules for the Moonlander and Planck EZ
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", \
      MODE:="0666", GROUP="plugdev", \
      SYMLINK+="stm32_dfu"
    '';
  };

  # enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mschwaig = {
    isNormalUser = true;
    extraGroups = [ "wheel" "wireshark" "plugdev" "adbusers" ];
    description = "Martin Schwaighofer";
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  programs.vim.defaultEditor = true;
  programs.wireshark.enable = true;

  fonts.fonts = with pkgs; [
    cascadia-code
  ];
}
