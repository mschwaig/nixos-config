{ config, pkgs, ... }:

{
  imports =
    [
      ./printers.nix
      ./wireguard.nix
    ];

    networking.wireless = {
      enable = true;
      userControlled.enable = true;
      allowAuxiliaryImperativeNetworks = true;
      networks.eduroam = {
        auth = ''
          ssid="eduroam"
          key_mgmt=WPA-EAP
          pairwise=CCMP
          group=CCMP TKIP
          eap=PEAP
          ca_cert="${./eduroam_ca.pem}"
          identity="***REMOVED AK NUMBER***@jku.at"
          altsubject_match="DNS:eduroam.jku.at"
          phase2="auth=MSCHAPV2"
          anonymous_identity="anonymous-cat_v2@jku.at"
        '';
      };

      #extraConfig = "ext_password_backend=file:/home/mschwaig/.cat_installer/passwords.conf";
    };

    services.upower = {
      enable = true;
      percentageLow = 25;
      percentageCritical = 15;
      percentageAction = 10;
    };
}
