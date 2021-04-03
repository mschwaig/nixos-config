{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-attest = {
      url = "https://git.ins.jku.at/proj/digidow/nixos-attest.git";
      type = "git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-attest }:

  with nixpkgs.lib;

  {

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
        ];
    };

    # thinkpad laptop
    nixosConfigurations.mutalisk = nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          ./machines/mutalisk.nix

          nixos-attest.nixosModules.attest

          ({ ... }: {
            system.configurationRevision = mkIf (self ? rev) self.rev;
          })
        ];
    };

};
}