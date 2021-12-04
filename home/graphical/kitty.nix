{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "Cascadia Code Semi Light";
      package = pkgs.cascadia-code;
    };
    settings = {
      bold_font = "Cascadia Code Regular";
      adjust_line_height = 1;
      disable_ligatures = "always";
      font_features = "none";
      touch_scroll_multiplier = "10.0";
      scrollback_pager_history_size = 8;
    };
    extraConfig = ''
      include ${./earthsong.conf}
    '';
  };

}
