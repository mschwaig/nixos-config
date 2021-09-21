{
  graphical = { pkgs, ... }: {
    imports = [ ./text ./graphical ];
  };

  terminal = { pkgs, ... }: {
    imports = [ ./text ];
  };
}

