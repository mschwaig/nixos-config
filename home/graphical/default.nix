{ pkgs, ... }: {

  imports = [
    ./kitty.nix
  ];

  home.packages = with pkgs; [
    firefox
    element-desktop
  ];

  programs.vscode = {
    enable = true;
    extensions = with pkgs; [
      vscode-extensions.valentjn.vscode-ltex
    ];
  };

}
