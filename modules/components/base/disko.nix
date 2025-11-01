{ inputs, ... }:
{
  flake.modules.nixos.base = {
    imports = [
      inputs.disko.nixosModules.default
    ];
  };
}
