{
  inputs = {
    deploy-rs.url = github:serokell/deploy-rs;
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

  outputs = { self, deploy-rs, nixpkgs, nixos-hardware, home-manager, nixos-attest, semi-secrets }@inputs:

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
    mapAttrsToList = pkgs.lib.attrsets.mapAttrsToList;
    nixosSystem = {...}@args: (nixpkgs.lib.nixosSystem  (args // {
      inherit pkgs system;
      # pass flake inputs to individual module files
      specialArgs = { inherit inputs; };
    }));
  in
 {
  deploy = {
    sshOpts = [ "-A" ];

    nodes = {
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
   );

    # home server
    nixosConfigurations.lair = nixosSystem {
      modules =
        [
          ./machines/lair.nix
        ];
    };

    # backup server
    nixosConfigurations.hatchery = nixosSystem {
      modules =
        [
          ./machines/hatchery.nix
        ];

    };

    # desktop pc
    nixosConfigurations.hydralisk = nixosSystem {
      modules =
        [
          ./machines/hydralisk.nix

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
      modules =
        [
          ./machines/mutalisk.nix

          nixos-hardware.nixosModules.lenovo-thinkpad-t480s


          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mschwaig = (import ./home).graphical;
          }
        ];
      };
  };
}
