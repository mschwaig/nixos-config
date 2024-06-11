{ inputs, pkgs, ... }: {

  imports = [ ./fish.nix ];

  home.packages = with pkgs; [
    p7zip
    alejandra
    hurl
    git-filter-repo
    haskellPackages.patat # try this fun presentation tool
    (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
    silver-searcher
    (ollama.override { acceleration = "rocm"; })
    oterm
    nmap
    nix-output-monitor
    nixpkgs-review
  ];

  programs = {
    nix-index.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    helix = {
      enable = true;
      package = inputs.helix.packages.${pkgs.system}.default;
      defaultEditor = true;
      extraPackages = [ pkgs.marksman ];

      settings = {
        theme = "base16_default";
        editor = {
          bufferline = "always";
          auto-pairs  = false;
          file-picker.follow-symlinks = false; # for nix result folders
          soft-wrap.enable  = true;
        };
      };
      languages = {
        language-server.nixd = {
          command = "${pkgs.nixd}/bin/nixd";
        };
        language = [{
          name = "nix";
          auto-format = false;
          language-servers = [ "nixd" "nil" ];
        }];
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
