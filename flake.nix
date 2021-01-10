{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }: {

    # home server
    nixosConfigurations.lair = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          ./machines/lair.nix
        ];
    };

    # backup server
    nixosConfigurations.hatchery = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          ./machines/hatchery.nix
        ];
    };

    # desktop pc
    nixosConfigurations.hydralisk = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          ./machines/hydralisk.nix
        ];
    };

    # thinkpad laptop
    nixosConfigurations.mutalisk = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [
          ./machines/mutalisk.nix
        ];
    };

};
}
