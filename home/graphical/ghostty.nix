{ pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      theme = "flexoki-dark";
    };
  };

  home.packages = [
    (pkgs.writeShellApplication {
      name = "ghostty-light";
      text = ''
        ${pkgs.ghostty}/bin/ghostty --config ${./tango_light.conf}
      '';
    })
  ];
}
