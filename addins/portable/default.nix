{ config, pkgs, lib, ... }:
with lib;
{
  imports =
    [
      ./printers.nix
      ./wireguard.nix
    ];

  options = {
    wifi-networks = {
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
    ak-number = mkOption {
      type = types.str;
      description = "JKU University Employee Number";
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
          identity="${ak-number}@ins.jku"
          altsubject_match="DNS:eduroam.jku.at"
          phase2="auth=MSCHAPV2"
          anonymous_identity="anonymous-cat_v2@jku.at"
          password="@EDUROAM_PASSWORD@"
        '';
      };

      networks.${config.wifi-networks.home-network-ssid} = {
        auth = ''
          proto=WPA2
          key_mgmt=WPA-PSK
          pairwise=CCMP
          group=CCMP
          psk="@HOME_NETWORK_PSK@"
        '';
      };

      networks.${config.wifi-networks.mobile-network-ssid} = {
        auth = ''
          proto=WPA2
          key_mgmt=WPA-PSK
          pairwise=CCMP
          group=CCMP
          psk="@MOBILE_NETWORK_PSK@"
        '';
      };

      networks.${config.wifi-networks.parent-network-ssid} = {
        auth = ''
          proto=WPA2
          key_mgmt=WPA-PSK
          pairwise=CCMP
          group=CCMP
          psk="@PARENT_NETWORK_PSK@"
        '';
      };
      environmentFile = "/home/mschwaig/.wifi-passwords.csv";
    };

    services.upower = {
      enable = true;
      percentageLow = 25;
      percentageCritical = 15;
      percentageAction = 10;
    };
  };
}
