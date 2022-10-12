{ config, pkgs, lib, ... }:
with lib;
let
  mapAttrs = pkgs.lib.attrsets.mapAttrs;
in
{
  imports =
    [
      ./printers.nix
      ./wireguard.nix
    ];

  options = {
    wifi-ssids = mkOption {
      type = types.attrsOf types.str;
      description = "SSIDs for all saved wifi networks.";
    };
    ak-number = mkOption {
      type = types.str;
      description = "JKU University Employee Number";
    };
  };
  config = {
    nix = {
      settings = {
        substituters = [ "http://lair.mschwaig.github.beta.tailscale.net/" "http://cache.nix.ins.jku.at" ];
        trusted-public-keys = [ "lair.mschwaig.github.beta.tailscale.net:6RWQD3CFGg9OY4bhqPzBumZ+o70lIEVH3R9bxTj+FXw=" "cache.nix.ins.jku.at:CPefhQ5WiLuI6Bc9T8sErWf0n5Jwu5Pl+i3B2tFg+/U=" ];
      };
    };
    networking.wireless = {
      enable = true;
      userControlled.enable = true;
      allowAuxiliaryImperativeNetworks = true;
      networks = mapAttrs' (name: value: nameValuePair value {
        auth = ''
          proto=WPA2
          key_mgmt=WPA-PSK
          pairwise=CCMP
          group=CCMP
          psk="@${lib.strings.toUpper name}_NETWORK_PSK@"
        '';
      }) (config.wifi-ssids) // {
        eduroam = {
          auth = ''
            ssid="eduroam"
            key_mgmt=WPA-EAP
            pairwise=CCMP
            group=CCMP TKIP
            eap=PEAP
            ca_cert="${./eduroam_ca.pem}"
            identity="${config.ak-number}@jku.at"
            altsubject_match="DNS:eduroam.jku.at"
            phase2="auth=MSCHAPV2"
            anonymous_identity="anonymous-cat_v2@jku.at"
            password="@EDUROAM_PASSWORD@"
          '';
        };
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
