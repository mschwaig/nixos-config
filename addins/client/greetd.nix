{ config, pkgs, ... }:

# The issue this solves:
# https://gitlab.freedesktop.org/drm/nouveau/-/issues/36
let launch_sway = pkgs.writeScriptBin "launch_sway.sh" ''
    #!${pkgs.bash}/bin/bash
    export WLR_DRM_NO_MODIFIERS=1
    ${pkgs.sway}/bin/sway --my-next-gpu-wont-be-nvidia
  '';
in
{
  users.users.greeter.group = "greeter";
  users.groups.greeter = {};

  services.greetd = {
    enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${launch_sway}/bin/launch_sway.sh";
          user = "greeter";
        };
        initial_session = {
          command = "${launch_sway}/bin/launch_sway.sh";
          user = "mschwaig";
        };
      };
  };
}
