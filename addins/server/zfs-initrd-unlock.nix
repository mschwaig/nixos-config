{ config, pkgs, ... }:
let
  sharedKeys = [
    # mutalisk
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKnthNhO1+KJ27ctGf+zUtYNgUORUegCm+4CX/X1W9+S"
    # hydralisk
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnU1xQN50B54S98io0kH1xElc9yNqmZMPF0s8QASLaB"
  ];
  unlock-shell = pkgs.writeShellScriptBin "unlock-shell" ''
    systemd-tty-ask-password-agent --query || true
    exec /bin/sh -l
  '';
in
{
  boot = {
    initrd = {
      systemd = {
        enable = true;
        network.enable = true;
        storePaths = [ "${unlock-shell}/bin/unlock-shell" ];
        users.root.shell = "${unlock-shell}/bin/unlock-shell";
      };
      network.ssh = {
        enable = true;
        port = 2222;
        hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
        authorizedKeys = sharedKeys;
      };
    };
  };

  users.users.mschwaig.openssh.authorizedKeys.keys = sharedKeys;
}