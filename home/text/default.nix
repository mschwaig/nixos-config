{ pkgs, ... }: {

  imports = [ ./fish.nix ];

  home.packages = [ pkgs.p7zip ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      userName = "Martin Schwaighofer";
      userEmail = "mschwaig@users.noreply.github.com";
      extraConfig = {
        pull = { ff = "only"; };
        credential = { helper = "cache"; };
        init = { defaultBranch = "main"; };
        url = {
          "ssh://git@git.ins.jku.at/" = {
            insteadof = "https://git.ins.jku.at/";
          };
          "ssh://git@github.com/" = {
            insteadof = "https://github.com/";
          };
        };
      };
    };
  };
}
