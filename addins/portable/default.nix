{ config, pkgs, lib, ... }:
with lib;
{
  imports =
    [
      ./printers.nix
      ./wireguard.nix
    ];

  options.wifi-networks = {
    home-network-ssid = mkOption {
      type = types.str;
      description = "SSID of my home wifi network.";
    };
    mobile-network-ssid = mkOption {
      type = types.str;
      description = "SSID of my phone tethering wifi network.";
    };
    parent-network-ssid = mkOption {
      type = types.str;
      description = "SSID of my parent's home network.";
    };
  };
  config = {
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

      networks.${config.wifi-networks.home-network-ssid} = {
        auth = ''
          proto=WPA2
          key_mgmt=WPA-PSK
          pairwise=CCMP
          group=CCMP
        '';
      };

      networks.${config.wifi-networks.mobile-network-ssid} = {
        auth = ''
          proto=WPA2
          key_mgmt=WPA-PSK
          pairwise=CCMP
          group=CCMP
        '';
      };

      networks.${config.wifi-networks.parent-network-ssid} = {
        auth = ''
          proto=WPA2
          key_mgmt=WPA-PSK
          pairwise=CCMP
          group=CCMP
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
  };
}
