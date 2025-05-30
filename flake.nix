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
    helix = {
      url = github:helix-editor/helix;
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-attest = {
      url = "https://git.ins.jku.at/proj/digidow/nixos-attest.git";
      type = "git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    roc.url = "github:roc-lang/roc";
  };

  outputs = { self, deploy-rs, nixpkgs, ... }@inputs:

  let
    system = "x86_64-linux";
    update-systemd-resolved-overlay = (_: super: {
      update-systemd-resolved = super.update-systemd-resolved.overrideAttrs (old: {
      patches = (old.patches or []) ++ [(
        super.fetchpatch {
          url = "https://github.com/jonathanio/update-systemd-resolved/commit/04ad1d1732ecb4353d6ce997b3e13b0ae710edd3.patch";

          sha256 = "sha256-h0xot8nWKvlbhRm6BVF2V5S8z19NI31GRRAWUetNU88=";
        })];
      });
    });
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ update-systemd-resolved-overlay ];
      config.allowUnfree = true;
    };
    pkgsWithRocm = import nixpkgs {
      inherit system;
      overlays = [ update-systemd-resolved-overlay ];
      config.allowUnfree = true;
      config.rocmSupport = true;
    };
    mapAttrsToList = pkgs.lib.attrsets.mapAttrsToList;
    nixosSystem = {...}@args: (nixpkgs.lib.nixosSystem ({
      inherit pkgs system;
      # pass flake inputs to individual module files
      specialArgs = { inherit inputs; };
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
  };
}
