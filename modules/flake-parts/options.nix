{ lib, flake-parts-lib, config, ... }:
{

  # Load Options
  # config.perSystem = { pkgs, config, ... }: {
  #   config.utils = import ./_utilities.nix { inherit pkgs; };
  #   # utils = {};
  #   # configData = {};
  # };

  # config = {
  #   configData = import ../../config-data.nix;
  #   utils = import ./_utilities.nix;
  # };
}
