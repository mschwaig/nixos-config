{
  inputs = {
    deploy-rs.url = github:serokell/deploy-rs;
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    robotnix.url = github:danielfullmer/robotnix;
    nixos-attest = {
      url = "https://git.ins.jku.at/proj/digidow/nixos-attest.git";
      type = "git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    semi-secrets = {
      # contains a salt and secrets that are fine inside /nix/store
      # but that I would rather not share on the public internet
      # {
      #   salt = "[256 bits of private randomness]";
      #   endpointip = "";
      #   ...
      # }
      url = "git+ssh://git@github.com/mschwaig/semi-secrets.git?ref=main";
    };
  };

  outputs = { self, deploy-rs, nixpkgs, nixos-hardware, home-manager, robotnix, nixos-attest, semi-secrets }:

  with nixpkgs.lib;
  let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
    mapAttrsToList = pkgs.lib.attrsets.mapAttrsToList;
  in
 {
  deploy = {
    sshOpts = [ "-A" ];

    nodes = {
      lair = {
        hostname = "lair.lan";
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.lair;
        };
      };
      hatchery = {
        hostname = "hatchery.lan";
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.hatchery;
        };
      };
    };
  };

   # add deploy-rs deployment checks to prevent errors
   checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

   defaultPackage."x86_64-linux" = pkgs.linkFarm "nixos-all" (
     mapAttrsToList(n: v:
       { name = n; path = v.config.system.build.toplevel;})
       self.nixosConfigurations
   );

    # home server
    nixosConfigurations.lair = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          ./machines/lair.nix

          nixos-attest.nixosModules.attest

          # let 'nixos-version --json' know about the flake's git revision
          # not sure how to move this to a module because of ref to self
          # nixpkgs.lib -> lib
          # self -> ?

          ({ ... }: {
            system.configurationRevision = mkIf (self ? rev) self.rev;
          })
        ];
    };

    # backup server
    nixosConfigurations.hatchery = nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          ./machines/hatchery.nix

          nixos-attest.nixosModules.attest

          ({ ... }: {
            system.configurationRevision = mkIf (self ? rev) self.rev;
          })
        ];

    };

    # desktop pc
    nixosConfigurations.hydralisk = nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          ./machines/hydralisk.nix

          nixos-attest.nixosModules.attest

          ({ lib, ... }: {
            system.configurationRevision = mkIf (self ? rev) self.rev;
          })

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mschwaig = (import ./home).graphical;
          }
        ];
    };

    # thinkpad laptop
    nixosConfigurations.mutalisk = nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          ./machines/mutalisk.nix

          nixos-attest.nixosModules.attest
          nixos-hardware.nixosModules.lenovo-thinkpad-t480s

          ({ ... }: {
            wireguard.endpointip = semi-secrets.lib.endpointip;
            wifi-networks.home-network-ssid = semi-secrets.lib.home-network-ssid;
            wifi-networks.mobile-network-ssid = semi-secrets.lib.mobile-network-ssid;
            wifi-networks.parent-network-ssid = semi-secrets.lib.parent-network-ssid;
            system.configurationRevision = mkIf (self ? rev) self.rev;
          })

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mschwaig = (import ./home).graphical;
          }
        ];
      };

      robotnixConfigurations."spore" =
        robotnix.lib.robotnixSystem ( { config, pkgs, ... }: import ./machines/spore.nix );
  };
}
