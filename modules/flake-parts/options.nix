{ lib, flake-parts-lib, ... }:
{
  # Define Options
  options.perSystem = flake-parts-lib.mkPerSystemOption ({ options, config, ... }: {
    options = {
      utils = lib.mkOption {
        type = lib.types.attrs;
        readOnly = true;
        description = "Project-specific system-dependent library functions.";
      };

      configData = lib.mkOption {
        type = lib.types.attrs;
        readOnly = true;
      };
    };
  });

  # Load Options
  config.perSystem = { pkgs, ... }: {
    # utils = import ./_utilities.nix { inherit pkgs; };
    # configData = import ../../config-data.nix;
    utils = {};
    configData = {};
  };
}
