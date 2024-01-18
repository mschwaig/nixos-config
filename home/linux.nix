{ inputs, pkgs, ... }:

inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  modules = [ ./text ./graphical ({...}: {
    home.stateVersion = "23.11";
    home.username = "deck";
    home.homeDirectory = "/home/deck";
    programs.home-manager.enable = true;
    }) ];
  extraSpecialArgs = {
    inherit inputs;
  };
}
