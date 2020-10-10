{ config, pkgs, ... }:
let
  unstable = import <nixos> {};
  # next line is required on servers because they are not running the unstable release
  # unstable = import <nixos-unstable> {};
in {
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.requestEncryptionCredentials = true;
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;

  # crate ZFS snapshots
  systemd.services.pyznap-snap = rec {
    description = "Run pyznap snap every 10 minutes to create regular ZFS snapshots";
    startAt = "*:00/10:00";
    path = [ unstable.pyznap pkgs.which pkgs.zfs ]; # should pyznap depend on which and zfs directly? idk
    serviceConfig = {
      User = "mschwaig";
      ExecStart = "${unstable.pyznap}/bin/pyznap -v --config /home/mschwaig/.config/pyznap/pyznap.conf snap";
    };
  };

}
