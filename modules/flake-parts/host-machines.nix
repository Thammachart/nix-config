{ inputs, lib, config, ... }:
let
  prefix = "hosts_";
  collectHostsModules = modules: lib.filterAttrs (name: _: lib.hasPrefix prefix name) modules;
in
{
  # All Systems to evaluate
  systems = [
    "x86_64-linux"
  ];

  flake.nixosConfigurations = lib.pipe (collectHostsModules config.flake.modules.nixos) [
    (lib.mapAttrs' (
      name: module:
      let
        hostname = lib.removePrefix prefix name;
        specialArgs = {
          inherit inputs;

          hostConfig = module // config.configData.hosts."${hostname}" // {
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
