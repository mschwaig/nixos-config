{ config, pkgs, ... }:

{
  services.openvpn.servers = {
    jku-ins-vpn  = {
      autoStart = false;
      config = '' config /root/.openvpn/schwaighofer@ads2-fim.fim.uni-linz.ac.at__ssl_vpn_config.ovpn '';    };
  };
}
