{ config, pkgs, ... }:

{
  services.openvpn.servers = {
    jku-ins-vpn  = {
      autoStart = false;
      # the line
      # auth-user-pass
      # is replaced by
      # auth-user-pass /root/.openvpn/credentials.txt
      # inside that file
      # because systemd trying to prompt for that password was a pain
      config = '' config /root/.openvpn/schwaighofer@ads2-fim.fim.uni-linz.ac.at__ssl_vpn_config.ovpn '';    };
  };
}
