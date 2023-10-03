{ inputs, lib, ... }: {
  imports = [
    inputs.nixos-attest.nixosModules.attest
  ];

  # let 'nixos-version-json' know about the flake's git revision
  system.configurationRevision = lib.mkIf (inputs.self ? rev) inputs.self.rev;
}