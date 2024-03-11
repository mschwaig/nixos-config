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
      ../encrypted-zfs-root
      ../common.nix

      inputs.home-manager.nixosModules.home-manager
      ../../home/nixos.nix
    ];

  nix = {
    settings = {
      substituters = [ "https://cache.nixos.org" ];
      trusted-public-keys = [ "lair.mschwaig.github.beta.tailscale.net:6RWQD3CFGg9OY4bhqPzBumZ+o70lIEVH3R9bxTj+FXw=" ];
    };
    extraOptions = ''
      keep-derivations = true
      keep-outputs = true
      experimental-features = nix-command flakes ca-derivations impure-derivations
    '';
  };

  services = {
    xserver = {
      enable = true;
      desktopManager.plasma6.enable = true;
    };
    pipewire.enable = true;
  };
  security.rtkit.enable = true;

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # for sysprog VMs
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "mschwaig" ];

  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "mschwaig" ];

  # move this to common.nix?
  networking.useNetworkd = true;
  # useNetwork seems to want it enabled in newer version
  # so this line is commented out for now
  systemd.network.wait-online.anyInterface = true;

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

    kitty

    # terminal apps
    file ffmpeg htop bandwhich git lolcat vifm-full tree archivemount pwgen jq tmux reptyr astyle protonvpn-cli_2 zip zstd tmate unzip tealdeer xdelta wally-cli tmate wget man-pages shellcheck

    diffoscope

    # text processing
    pandoc recode

    (python3.withPackages(ps: with ps; [ qrcode ]))

    # for pdfinfo command
    poppler_utils

    element-desktop

    vscode
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
