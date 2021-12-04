{
  graphical = { pkgs, ... }: {
    imports = [ ./text ./graphical ];
    home.file.".config/pyznap/pyznap.conf".source = ./pyznap.conf;
  };

  terminal = { pkgs, ... }: {
    imports = [ ./text ];
  };
}

