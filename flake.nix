{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/113823669b9b71fff84bc592d1fd6022635c28eb;
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    semi-secrets = {
      # contains a salt and secrets that are fine inside /nix/store
      # but that I would rather not share on the public internet
      # {
      #   salt = "[256 bits of private randomness]";
      #   endpointip = "";
      # }
      url = "/home/mschwaig/.semi-secrets.nix";
      flake = false;
    };
    nixos-attest = {
      url = "https://git.ins.jku.at/proj/digidow/nixos-attest.git";
      type = "git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, semi-secrets, nixos-attest }:

  with nixpkgs.lib;
  let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
    mapAttrsToList = pkgs.lib.attrsets.mapAttrsToList;
  in
 {
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
            home-manager.users.mschwaig = import ./home.nix;
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
            wireguard.endpointip = (import semi-secrets).endpointip;
            system.configurationRevision = mkIf (self ? rev) self.rev;
          })

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mschwaig = import ./home.nix;
          }
        ];
    };

};
}
