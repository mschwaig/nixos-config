{ config, pkgs, ... }:

{
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "fdf1:e8a1:8d3f:9::2/64" "192.168.9.2/24" ];
      privateKeyFile = "/home/mschwaig/.wg/privatekey";

      peers = [
        {
          # Edge Router X
          publicKey = "ECpzlXbRNyuV79RS3qEqp/V9I7qGpKZ4TjXiwiPa4hU=";

          # additional PSK for post-quantum secrecy
          presharedKeyFile = "/home/mschwaig/.wg/presharedkey";

          # subnets to forward
          allowedIPs = [
            "192.168.9.1"
            "192.168.1.0/24"
            "fdaf:e4ed:daaa::/48"
            "fdf1:e8a1:8d3f:9::1"
          ];

          # server ip and port
          endpoint = "***REMOVED IP***:51820";

          # to get through NAT on server-side
          persistentKeepalive = 25;
        }
      ];
    };
  };

  #networking.nameservers = ["fdf1:e8a1:8d3f:9::1"];

  #services.dnsmasq = {
  #  enable = true;
  #  extraConfig = ''
  #    interface=wg0
  #    '';
  #};
}
