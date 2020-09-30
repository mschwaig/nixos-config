{ config, pkgs, ... }:

{
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "192.168.9.2/32" "fdf1:e8a1:8d3f:9::2/128" ];
      privateKeyFile = "/home/mschwaig/.wg/privatekey";

      dns = [ "192.168.1.1" ];

      peers = [
        {
          # Edge Router X
          publicKey = "ECpzlXbRNyuV79RS3qEqp/V9I7qGpKZ4TjXiwiPa4hU=";

          # additional PSK for post-quantum secrecy
          presharedKeyFile = "/home/mschwaig/.wg/presharedkey";

          # subnets to forward
          allowedIPs = [
            "192.168.9.1/24"
            "192.168.1.1/24"
            "fdaf:e4ed:daaa::1/60"
          ];

          # server ip and port
          endpoint = "***REMOVED IP***:51820";

          # to get through NAT on server-side
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
