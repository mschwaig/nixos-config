{ config, pkgs, ... }:

{
  # Run weechat as a systemd user unit:
  # https://wiki.archlinux.org/index.php/WeeChat#Tmux_Method

  environment.systemPackages = with pkgs; [ weechat tmux ];

  # crate ZFS snapshots
  systemd.services.weechat = rec {
    description = "A WeeChat client and relay service using Tmux";
    after = [ "network.target" ];
    path = with pkgs; [ weechat tmux ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "forking";
      User = "mschwaig";
      RemainAfterExit = true;
      ExecStart = "${pkgs.tmux}/bin/tmux -L weechat new -d -s weechat ${pkgs.weechat}/bin/weechat";
      ExecStop="${pkgs.tmux}/bin/tmux -L weechat kill-session -t ${pkgs.weechat}/bin/weechat";
    };
  };

}


