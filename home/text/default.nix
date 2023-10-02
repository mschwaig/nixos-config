{ pkgs, ... }: {

  imports = [ ./fish.nix ];

  home.packages = with pkgs; [ p7zip helix alejandra hurl ];

  programs = {
    nix-index.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    helix = {
      enable = true;
      defaultEditor = true;
       settings = {
        theme = "base16_default";
        editor.soft-wrap.enable  = true;
      };
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
          "ssh://git@github.com/mschwaig" = {
            insteadof = "https://github.com/mschwaig";
          };
        };
      };
    };
  };
}
