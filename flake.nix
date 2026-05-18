{
  inputs = {
    deploy-rs = {
      url = github:serokell/deploy-rs;
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = github:numtide/flake-utils;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    nixpkgs.url = github:nixos/nixpkgs/1c3fe55ad329cbcb28471bb30f05c9827f724c76;
    latest-nixpkgs.url = github:mschwaig/nixpkgs/ollama-11.4;
    roc.url = "github:roc-lang/roc";
  };

  outputs = { self, deploy-rs, nixpkgs, ... }@inputs:

  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    latest-pkgs = import inputs.latest-nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    pkgsWithRocm = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.rocmSupport = true;
    };
    mapAttrsToList = pkgs.lib.attrsets.mapAttrsToList;
    nixosSystem = {...}@args: (nixpkgs.lib.nixosSystem ({
      inherit pkgs system;
      # pass flake inputs to individual module files
      specialArgs = { inherit inputs latest-pkgs; };
    } // args));
  in
 {
  deploy = {
    sshOpts = [ "-A" ];

    nodes = {
      hydralisk = {
        hostname = "hydralisk";
        profiles.system = {
          user = "mschwaig";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.hydralisk;
        };
      };
      mutalisk = {
        hostname = "mutalisk";
        profiles.system = {
          user = "mschwaig";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.mutalisk;
        };
      };
      lair = {
        hostname = "lair";
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.lair;
        };
      };
      hatchery = {
        hostname = "hatchery";
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.hatchery;
        };
      };
      hive = {
        hostname = "hive";
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.hive;
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
      # TODO: add home-manager config
   );

   homeConfigurations."deck" = pkgs.callPackage ./home/linux.nix { inherit inputs; };

    # home server
    nixosConfigurations.lair = nixosSystem {
      modules = [
          ./machines/lair.nix
        ];
    };

    # backup server
    nixosConfigurations.hatchery = nixosSystem {
      modules = [
          ./machines/hatchery.nix
      ];
    };

    # desktop pc
    nixosConfigurations.hydralisk = nixosSystem {
      pkgs = pkgsWithRocm;
      modules = [
        ./machines/hydralisk.nix
      ];
    };

    # framework laptop
    nixosConfigurations.mutalisk = nixosSystem {
      pkgs = pkgsWithRocm;
      modules = [
        ./machines/mutalisk.nix
      ];
    };

    # framework desktop server
    nixosConfigurations.hive = nixosSystem {
      modules = [
        ./machines/hive.nix
      ];
    };
  };
}
