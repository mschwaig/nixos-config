{ config, pkgs, lib, ... }:

let
  nvidiaPackage = config.boot.kernelPackages.nvidiaPackages.stable;

  extraEnv = { WLR_NO_HARDWARE_CURSORS = "1"; };
  nvidia-wlroots-overlay = (final: prev: {
    wlroots = prev.wlroots.overrideAttrs(old: {
      # HACK: https://forums.developer.nvidia.com/t/nvidia-495-does-not-advertise-ar24-xr24-as-shm-formats-as-required-by-wayland-wlroots/194651
      postPatch = ''
        sed -i 's/assert(argb8888 &&/assert(true || argb8888 ||/g' 'render/wlr_renderer.c'
      '';
    });
  });
in
{
  config = {
    environment.variables = extraEnv;
    # next line is done in home-manager instead
    # environment.sessionVariables = extraEnv;

    nixpkgs.overlays = [ nvidia-wlroots-overlay ];
    environment.systemPackages = with pkgs; [
      vulkan-tools
      glmark2
    ];

    hardware.nvidia = {
      modesetting.enable = true;
      package = nvidiaPackage;
      powerManagement.enable = false;
    };

    services.xserver = {
      videoDrivers = [ "nvidia" ];
    };
  };
}
