{ config, pkgs, ... }:

# See
# https://nixos.wiki/wiki/Binary_Cache
# and
# https://nixos.org/manual/nix/stable/#sec-sharing-packages
# for docs.
{
  networking.firewall.allowedTCPPorts = [ 80 ];

  services.nix-serve = {
    enable = true;
    secretKeyFile = "/var/cache-priv-key.pem";
    bindAddress = "localhost";
  };

  services.nginx = {
    enable = true;
    virtualHosts = {
      "lair.lan" = {
        serverAliases = [ "binarycache" ];
        locations."/".extraConfig = ''
          proxy_pass http://localhost:${toString config.services.nix-serve.port};
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        '';
      };
    };
  };
}
