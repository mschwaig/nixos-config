{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [sshfsFuse unison];

  # note that this still requires connecting manually once as root for the remote key to show up in root's known hosts file
  # See: https://blog.luukhendriks.eu/2019/01/25/sshfs-too-many-levels-of-symbolic-links.html
  systemd.mounts = [
    {
      what = "mschwaig@srv:/mnt/data";
      where = "/mnt/data";
      type = "fuse.sshfs";
      options = "identityfile=/home/mschwaig/.ssh/id_ed25519,allow_other,uid=1000,gid=100";
      wantedBy = [ "default.target" ];
    }
  ];

  systemd.automounts = [
    { where = "/mnt/data";
      automountConfig = { TimeoutIdleSec = "600"; };
      wantedBy = [ "default.target" ];
    }
  ];

    # crate ZFS snapshots
  systemd.services.unison = rec {
    description = "Run unison about every 10 minutes to sync profile files to server";
    startAt = "*:00/10:00";
    # randomizedDelaySec = "10 min"; fully randomize sync times to prevent races
    # before = "sleep.target"; TODO: try something like this to sync before going offline
    path = with pkgs; [ unison openssh ];
    serviceConfig = {
      User = "mschwaig";
      ExecStart = "${pkgs.unison}/bin/unison default";
    };
  };

}


