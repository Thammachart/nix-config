{ inputs, ... }:
{
  perSystem = { system, config, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config = {
        # allowUnfreePredicate = pkg: true;
        allowUnfree = true;
      };
      overlays = [
        (final: prev: {
          local = config.packages;
        })
      ];
    };
    pkgsDirectory = ../../pkgs/by-name;
  };
}
