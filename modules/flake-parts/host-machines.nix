{ inputs, lib, config, ... }:
let
  configData = import ../../config-data.nix;

  prefix = "hosts/";
  collectHostsModules = modules: lib.filterAttrs (name: _: lib.hasPrefix prefix name) modules;
in
{
  flake.nixosConfigurations = lib.pipe (collectHostsModules config.flake.modules.nixos) [
    (lib.mapAttrs' (
      name: module:
      let
        hostname = lib.removePrefix prefix name;
        specialArgs = {
          inherit inputs;

          hostConfig = module // configData.hosts."${hostname}" // {
            hostname = hostname;
          };
        };
      in
      {
        name = hostname;
        value = inputs.nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = module.imports ++ [
            inputs.home-manager.nixosModules.home-manager {
              home-manager.extraSpecialArgs = specialArgs;
            }
          ];
        };
      }
    ))
  ];
}
