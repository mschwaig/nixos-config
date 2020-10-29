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
          PublicKey=ECpzlXbRNyuV79RS3qEqp/V9I7qGpKZ4TjXiwiPa4hU=
          PresharedKey=${builtins.readFile /home/mschwaig/.wg/presharedkey}
          PersistentKeepalive=25
          AllowedIPs=192.168.9.1, 192.168.1.0/24
          AllowedIPs=fdf1:e8a1:8d3f:9::1, fdaf:e4ed:daaa::/64
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
        DNS=fdaf:e4ed:daaa::1
        DNS=192.168.1.1
        DNSDefaultRoute=true
        Domains=~.


        # IP addresses the client interface will have
        [Address]
        Address=192.168.9.2/24
        [Address]
        Address=fdf1:e8a1:8d3f:9::2/64
        [Address]
        Address=fe80::/64

        [Route]
        Destination=192.168.1.0/24
        Scope=link

        [Route]
        Destination=fdaf:e4ed:daaa::/64
        Scope=link
      '';
    };
  };
}
