{ config, inputs, lib, pkgs, system, ... }:

{
  imports =
    [
      ./steam.nix
      ./sync.nix
      ./scarlett-audio.nix
      ./thunderbolt.nix
      ./bluetooth.nix
      ./vacuum.nix
      ../common.nix

      inputs.home-manager.nixosModules.home-manager
      ../../home/nixos.nix
    ];

  nix = {
    settings = {
      substituters = [ "https://cache.nixos.org" ];
      trusted-public-keys = [ "lair.van-duck.ts.net.net:6RWQD3CFGg9OY4bhqPzBumZ+o70lIEVH3R9bxTj+FXw=" ];
    };
    gc = {
      automatic = true;
      persistent = true;
      dates = "14:00";
      randomizedDelaySec = "4h";
      # free 10+20 GB if we dip under 10 GB of free space
      # on the /nix/store partition
      options = "--min-free = ${ toString (10 * 1024 * 1024 * 1024) } --max-free = ${ toString (30 * 1024 * 1024 * 1024) }";
    };
    extraOptions = ''
      keep-derivations = true
      keep-outputs = true
      experimental-features = nix-command flakes ca-derivations impure-derivations
    '';
  };

  services = {
    xserver.enable = false;
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    pipewire.enable = true;
  };
  security.rtkit.enable = true;

  zramSwap.enable = true;
  hardware.pulseaudio.enable = false;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # move this to common.nix?
  networking = {
    useNetworkd = true;
    firewall.trustedInterfaces = [ "tailscale0" ];
  };

  services.resolved = {
    enable = true;
    #extraConfig = ''
    #  DNSOverTLS=yes
    #'';
  };

  boot.supportedFilesystems = [ "ntfs" "fuse-7z-ng" ];

  environment.systemPackages = with pkgs; [
    # gui apps
    thunderbird vlc gimp transmission-gtk libreoffice-fresh chromium inkscape audacity reaper

    nix-diff
    nix-tree

    cue

    amdgpu_top

    # tiling-friendly apps
    sxiv zathura

    # video editing
    kdePackages.kdenlive

    # webcam
    guvcview

    # disk usage
    gdu

    # development tools
    zig valgrind gdb gnumake gcc cntr dhall hare sublime-merge # gdbgui

    kitty

    # terminal apps
    file ffmpeg htop bandwhich git lolcat tree archivemount pwgen jq tmux reptyr astyle protonvpn-cli_2 zip zstd tmate unzip tealdeer xdelta wally-cli tmate wget man-pages shellcheck

    diffoscope

    # text processing
    pandoc recode

    (python3.withPackages(ps: with ps; [ qrcode ]))

    # for pdfinfo command
    poppler_utils

    element-desktop

    waypipe
  ];

  environment.sessionVariables = {
    # use wayland backend for QT apps to make waypipe work
    QT_QPA_PLATFORM="wayland";
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mschwaig = {
    extraGroups = [ "wireshark" "plugdev" "adbusers" ];
  };

  programs.wireshark.enable = true;
  programs.sysdig.enable = true;
}
