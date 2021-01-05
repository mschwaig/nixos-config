{ config, pkgs, ... }:

{
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.requestEncryptionCredentials = true;
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;

  environment.systemPackages = with pkgs; [
    pyznap
  ];

  # crate ZFS snapshots
  systemd.services.pyznap-snap = rec {
    description = "Run pyznap snap every 10 minutes to create regular ZFS snapshots";
    startAt = "*:00/10:00";
    path = [ pkgs.pyznap pkgs.which pkgs.zfs ]; # should pyznap depend on which and zfs directly? idk
    serviceConfig = {
      User = "mschwaig";
      ExecStart = "${pkgs.pyznap}/bin/pyznap -v --config /home/mschwaig/.config/pyznap/pyznap.conf snap";
    };
  };

}
