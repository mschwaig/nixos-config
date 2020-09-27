{ config, pkgs, ... }:

{
  boot.supportedFilesystems = ["zfs"];
  boot.zfs.requestEncryptionCredentials = true;
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;
}
