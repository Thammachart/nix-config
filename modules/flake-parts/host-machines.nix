{ inputs, lib, config, ... }:
let
  configData = import ../../config-data.nix;

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
          inherit configData;
          inherit hostname;
          hostConfig = configData.hosts."${hostname}";
        };
      in
      {
        name = hostname;
        value = inputs.nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          # https://github.com/hercules-ci/flake-parts/commit/5635c32d666a59ec9a55cab87e898889869f7b71
          modules = (module {}).imports ++ [
            inputs.home-manager.nixosModules.home-manager {
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.useGlobalPkgs = true;
            }
          ];
        };
      }
    ))
  ];
}
