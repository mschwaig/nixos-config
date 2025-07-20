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
    nil
    nurl
    inputs.roc.packages.x86_64-linux.cli
    claude-code
    gh
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
      extraPackages = with pkgs; [
        marksman
        rust-analyzer
        rustfmt
        cargo
        clippy
        python3Packages.python-lsp-server
        python3Packages.black
        python3Packages.isort
        python3Packages.pylint
      ];

      settings = {
        theme = "base16_default";
        editor = {
          bufferline = "always";
          auto-pairs  = false;
          file-picker.follow-symlinks = false; # for nix result folders
          soft-wrap.enable  = true;
          lsp.display-messages = true;
          lsp.display-inlay-hints = true;
          auto-completion = true;
          idle-timeout = 0;
          completion-trigger-len = 1;
        };
      };
      languages = {
        language = [
          {
            name = "nix";
            auto-format = false;
            language-servers = [ "nil" ];
          }
          {
            name = "rust";
            auto-format = true;
            formatter = { command = "rustfmt"; args = ["--edition" "2024"]; };
            language-servers = [ "rust-analyzer" ];
          }
          {
            name = "python";
            auto-format = false;
            formatter = { command = "black"; args = ["--quiet" "-"]; };
            language-servers = [ "pylsp" ];
          }
        ];
      };
    };

    git = {
      enable = true;
      userName = "Martin Schwaighofer";
      userEmail = "3856390+mschwaig@users.noreply.github.com";
      extraConfig = {
        log.date = "human";
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
