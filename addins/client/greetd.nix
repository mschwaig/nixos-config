{ config, pkgs, ... }:

{
  users.users.greeter.group = "greeter";
  users.groups.greeter = {};

  services.greetd = {
    enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${pkgs.sway}/bin/sway";
          user = "greeter";
        };
        initial_session = {
          command = "${pkgs.sway}/bin/sway";
          user = "mschwaig";
        };
      };
  };
}
