{ inputs, config, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules

    inputs.chaotic.nixosModules.default
    inputs.disko.nixosModules.disko
    inputs.sops-nix.nixosModules.sops
    inputs.auto-cpufreq.nixosModules.default

    inputs.home-manager.flakeModules.home-manager

    inputs.pkgs-by-name-for-flake-parts.flakeModule
  ];

  flake.nixosModules = config.flake.modules.nixos;
  flake.homeModules = config.flake.modules.homeManager;
}
