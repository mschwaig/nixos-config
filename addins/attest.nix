{ inputs, lib, ... }: {
  imports = [
    #inputs.nixos-attest.nixosModules.attest
  ];

  system.configurationRevision = lib.mkIf (inputs.self ? rev) inputs.self.rev;
}
