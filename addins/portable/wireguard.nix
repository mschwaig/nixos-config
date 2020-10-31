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
          MTUBytes = "1420";
          Name = "wg0";
        };
        extraConfig = ''
          [WireGuard]
          PrivateKey=${builtins.readFile /home/mschwaig/.wg/privatekey}
          [WireGuardPeer]
          PublicKey=rJxpeBSDQQLtNTIrrxgxbf4yqWKi6acd3N2PEYxWlWE=
          PresharedKey=${builtins.readFile /home/mschwaig/.wg/presharedkey}
          PersistentKeepalive=25
          AllowedIPs=192.168.98.1, 192.168.97.0/24
          AllowedIPs=fde4:c86b:cbd3:98::1, fde4:c86b:cbd3:97::1/64
          Endpoint=${builtins.readFile /home/mschwaig/.wg/endpointip}:51820
        '';
      };
    };
    networks = {
      "40-wg0".extraConfig = ''
        [Match]
        Name=wg0

        [Network]
        DHCP=none
        IPv6AcceptRA=false
        DNS=fde4:c86b:cbd3:97::1
        DNS=192.168.97.1
        DNSDefaultRoute=true
        Domains=~.


        # IP addresses the client interface will have
        [Address]
        Address=192.168.98.2/24
        [Address]
        Address=fde4:c86b:cbd3:98::2/64
        [Address]
        Address=fe80::/64

        [Route]
        Destination=192.168.97.0/24
        Scope=link

        [Route]
        Destination=fde4:c86b:cbd3:97::/60
        Scope=link
      '';
    };
  };
}
