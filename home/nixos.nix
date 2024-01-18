{ inputs, pkgs, ... }:
let
  graphical = { pkgs, ... }: {
    imports = [ ./text ./graphical ];
    home.file.".config/pyznap/pyznap.conf".source = ./pyznap.conf;
    home.stateVersion = "22.11";
  };
  terminal = { pkgs, ... }: {
    imports = [ ./text ];
    home.stateVersion = "22.11";
  };
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.mschwaig = graphical;
    extraSpecialArgs = {
      inherit inputs;
    };
  };
}
