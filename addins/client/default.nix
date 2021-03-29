{ config, pkgs, ... }:

{
  imports =
    [
      ./steam.nix
      ./sway.nix
      ./sync.nix
      ./scarlett-audio.nix
      ./thunderbolt.nix
      ../encrypted-zfs-root
      ../common.nix
    ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # move this to common.nix?
  networking.useNetworkd = true;
  systemd.services.systemd-networkd-wait-online.enable = false;

  networking.wireless.iwd.enable = true;

  boot.supportedFilesystems = [ "ntfs" "fuse-7z-ng" ];

  environment.systemPackages = with pkgs; [
    # gui apps
    firefox-bin thunderbird vlc gimp transmission-gtk libreoffice-fresh chromium inkscape audacity reaper

    discord

    # tiling-friendly apps
    sxiv zathura

    # video editing
    kdenlive mlt

    # development tools
    zig valgrind gdb gnumake gcc

    # terminl emulator (move to sway file?)
    kitty

    # terminal apps
    file ffmpeg htop bandwhich git lolcat vifm-full tree archivemount pwgen jq nix-index tmux reptyr astyle protonvpn-cli zip zstd tmate unzip tealdeer diffoscope xdelta wally-cli wget

    # text processing
    pandoc recode

    (python38.withPackages(ps: with ps; [ qrcode ]))

    # monitoring
    pulsemixer wireshark

    fuse-7z-ng
  ];

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
    extraGroups = [ "wireshark" "plugdev" "adbusers" ];
  };

  programs.wireshark.enable = true;

  fonts.fonts = with pkgs; [
    cascadia-code
  ];
}
