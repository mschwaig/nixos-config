{ pkgs, ... }: {

  imports = [
    ./kitty.nix
  ];

  home.packages = with pkgs; [
    firefox
  ];

  programs.vscode = {
    enable = true;
    extensions = with pkgs; [
      vscode-extensions.valentjn.vscode-ltex
    ];
  };

}
