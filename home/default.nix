{
  graphical = { pkgs, ... }: {
    imports = [ ./text ./graphical ];
    home.file.".config/pyznap/pyznap.conf".source = ./pyznap.conf;
    home.stateVersion = "22.11";
  };

  terminal = { pkgs, ... }: {
    imports = [ ./text ];
  };
}

