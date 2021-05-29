{ config, pkgs, ... }:

# The issue this solves:
# https://gitlab.freedesktop.org/drm/nouveau/-/issues/36
let launch_sway = pkgs.writeScriptBin "launch_sway.sh" ''
    #!${pkgs.bash}/bin/bash
    export WLR_DRM_NO_MODIFIERS=1
    ${pkgs.sway}/bin/sway
  '';
in
{
  services.greetd = {
    enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.greetd}/bin/tuigreet --time --cmd ${launch_sway}/bin/launch_sway.sh";
          user = "greeter";
        };
        initial_session = {
          command = "${launch_sway}/bin/launch_sway.sh";
          user = "mschwaig";
        };
      };
  };
}
