{ pkgs, ... }: {

  imports = [
    ./kitty.nix
    ./ghostty.nix
  ];

  home.packages = with pkgs; [
    firefox
    element-desktop
  ];

  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        valentjn.vscode-ltex
        jnoortheen.nix-ide
        ms-python.python
        ms-python.vscode-pylance
        ms-python.debugpy
        mkhl.direnv
      ];
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
    };
  };

}
