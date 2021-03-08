{ config, pkgs, ... }:

{
  # See instructions here for samba troubleshooting:
  # https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting

  fileSystems."/mnt/jku-ins" = {
    device = "//ads2-fim.fim.uni-linz.ac.at/all_root";
    fsType = "cifs";
    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        require_vpn = "x-systemd.requires=openvpn-jku-ins-vpn.service";
        credentials = "credentials=/home/mschwaig/.smb/secrets";
        # TODO: get rid of hardcoded uid/gids here (relate all of that to user)
        file_permissions = "uid=1000,gid=100,dir_mode=0775,file_mode=0644";
      in ["${automount_opts},${require_vpn},${credentials},${file_permissions}"];
    };

    # Manually resolve these specific hosts that are actually publicly resolvable under ads2-fim.fim.uni-linz.ac.at
    # because the SMB server does not give fully qualified domain names for them.
    # I would rather hardcode those specific hosts than hardcode their fully qulified domain to everything.
    # It looks like ads2-fim.fim.uni-linz.ac.at needs to resolve to those three host's same IPs as well and does not do that on public DNS, so I add that in the hosts file as well.
    networking.extraHosts = ''
      140.78.100.119 EDC1A
      140.78.100.126 EDC2A
      140.78.100.118 EDC3A
      140.78.100.119 ads2-fim.fim.uni-linz.ac.at
      140.78.100.126 ads2-fim.fim.uni-linz.ac.at
      140.78.100.118 ads2-fim.fim.uni-linz.ac.at
    '';

    environment.systemPackages = with pkgs; [
      # Doesn't *need* to be in the system profile for this to work, but we
      # want it installed so that e.g. the man pages are available
      cifs-utils
      # This *does* need to be installed in the system profile, as we link to
      # it in the symlink-requestkey activation script
      # the assumption is that keyutils is required because of what is described here:
      # https://bugs.launchpad.net/ubuntu/+source/samba/+bug/493565
      keyutils
    ];

    # request-key from keyutils expects a configuration file like that under /etc
    # a similar config of that file should be pretty standard with most distros when you install the keyutils package
    environment.etc."request-key.conf" = {
      text = let
        upcall = "${pkgs.cifs-utils}/bin/cifs.upcall";
        keyctl = "${pkgs.keyutils}/bin/keyctl";
      in ''
        #OP     TYPE          DESCRIPTION  CALLOUT_INFO  PROGRAM
        # -t is required for DFS share servers...
        create  cifs.spnego   *            *             ${upcall} -t %k
        create  dns_resolver  *            *             ${upcall} %k
        # Everything below this point is essentially the default configuration,
        # modified minimally to work under NixOS. Notably, it provides debug
        # logging.
        create  user          debug:*      negate        ${keyctl} negate %k 30 %S
        create  user          debug:*      rejected      ${keyctl} reject %k 30 %c %S
        create  user          debug:*      expired       ${keyctl} reject %k 30 %c %S
        create  user          debug:*      revoked       ${keyctl} reject %k 30 %c %S
        create  user          debug:loop:* *             |${pkgs.coreutils}/bin/cat
        create  user          debug:*      *             ${pkgs.keyutils}/share/keyutils/request-key-debug.sh %k %d %c %S
        negate  *             *            *             ${keyctl} negate %k 30 %S
      '';
    };

    # What follows is a NixOS specific fix from the linked GitHub issue.

    # Remove this once https://github.com/NixOS/nixpkgs/issues/34638 is resolved
    # The TL;DR is: the kernel calls out to the hard-coded path of
    # /sbin/request-key as part of its CIFS auth process, which of course does
    # not exist on NixOS due to the usage of Nix store paths.
    system.activationScripts.symlink-requestkey = ''
      if [ ! -d /sbin ]; then
        mkdir /sbin
      fi
      ln -sfn /run/current-system/sw/bin/request-key /sbin/request-key
    '';
}
