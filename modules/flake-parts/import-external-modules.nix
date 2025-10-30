{ inputs, config, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
    inputs.home-manager.flakeModules.home-manager
    inputs.pkgs-by-name-for-flake-parts.flakeModule
    inputs.disko.flakeModules.default
  ];

  # flake.nixosModules = [
  # ] ++ config.flake.modules.nixos;

  # flake.homeModules = config.flake.modules.homeManager;
}
