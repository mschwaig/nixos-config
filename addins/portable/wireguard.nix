{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  systemd.network = {
    enable = true;
    netdevs = {
      "10-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
        };
        extraConfig = ''
          [WireGuard]
          PrivateKeyFile=/etc/systemd/network/wg0/privatekey
          [WireGuardPeer]
          PublicKey=rJxpeBSDQQLtNTIrrxgxbf4yqWKi6acd3N2PEYxWlWE=
          PresharedKeyFile=/etc/systemd/network/wg0/presharedkey
          PersistentKeepalive=25
          AllowedIPs=192.168.98.1, 192.168.97.0/24
          Endpoint=${lib.removeSuffix "\n"
              (builtins.readFile /home/mschwaig/.wg/endpointip)
            }:51820
        '';
      };
    };
    networks = {
      "40-wg0".extraConfig = ''
        [Match]
        Name=wg0

        [Network]
        DHCP=no
        DNS=192.168.97.1
        DNSDefaultRoute=true
        Domains=~.

        # IP addresses the client interface will have
        [Address]
        Address=192.168.98.2/24

        [Route]
        Gateway=192.168.97.1
        Destination=192.168.97.0/24
        GatewayOnlink=true
     '';
    };
  };
}
