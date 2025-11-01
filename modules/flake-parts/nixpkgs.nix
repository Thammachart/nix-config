{ inputs, withSystem, ... }:
{
  perSystem = { system, config, ... }: {
    # _module.args.pkgs = import inputs.nixpkgs {
    #   inherit system;
    #   config.allowUnfree = true;
    #   overlays = [];
    # };
    pkgsDirectory = ../../pkgs/by-name;
  };

  flake = {
    overlays.default =
      final: prev:
      withSystem prev.stdenv.hostPlatform.system (
        { config, ... }: {
          local = config.packages;
        }
      );
  };
}
