{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./greetd.nix
      ./steam.nix
      ./sway.nix
      ./sync.nix
      ./scarlett-audio.nix
      ./thunderbolt.nix
      ./bluetooth.nix
      ../encrypted-zfs-root
      ../common.nix
    ];

  nix = {
    binaryCaches = [ "http://lair.lan/" "http://cache.nix.ins.jku.at" ];
    binaryCachePublicKeys = [ "lair.lan:6RWQD3CFGg9OY4bhqPzBumZ+o70lIEVH3R9bxTj+FXw=" "cache.nix.ins.jku.at:CPefhQ5WiLuI6Bc9T8sErWf0n5Jwu5Pl+i3B2tFg+/U=" ];
    # See: https://discourse.nixos.org/t/using-experimental-nix-features-in-nixos-and-when-they-will-land-in-stable/7401/4 which gives the reason for the optional thing
    extraOptions = ''
      keep-derivations = true
      keep-outputs = true
      experimental-features = nix-command flakes ca-derivations impure-derivations
    '';
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # for sysprog VMs
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "mschwaig" ];

  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "mschwaig" ];

  # move this to common.nix?
  networking.useNetworkd = true;
  systemd.services.systemd-networkd-wait-online.enable = false;

  boot.supportedFilesystems = [ "ntfs" "fuse-7z-ng" ];

  environment.systemPackages = with pkgs; [
    # gui apps
    firefox-wayland thunderbird vlc gimp transmission-gtk libreoffice-fresh chromium inkscape audacity reaper

    nix-diff
    nix-tree

    cue

    # communictaion
    discord skypeforlinux

    # tiling-friendly apps
    sxiv zathura

    # video editing
    kdenlive mlt

    # webcam
    guvcview

    # disk usage
    gdu

    # development tools
    zig valgrind gdb gnumake gcc cntr dhall hare sublime-merge # gdbgui

    # terminl emulator (move to sway file?)
    kitty

    # terminal apps
    file ffmpeg htop bandwhich git lolcat vifm-full tree archivemount pwgen jq nix-index tmux reptyr astyle protonvpn-cli_2 zip zstd tmate unzip tealdeer xdelta wally-cli tmate wget man-pages shellcheck

    diffoscope

    # text processing
    pandoc recode

    (python38.withPackages(ps: with ps; [ qrcode ]))

    # monitoring
    pulsemixer wireshark

    #fuse-7z-ng

    # for pdfinfo command
    poppler_utils

    # for screen-mirroring with sway
    gnome.vinagre wayvnc
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mschwaig = {
    extraGroups = [ "wireshark" "plugdev" "adbusers" ];
  };

  programs.wireshark.enable = true;
  programs.sysdig.enable = true;
}
