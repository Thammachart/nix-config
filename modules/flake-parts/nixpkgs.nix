{ inputs, withSystem, ... }:
{
  perSystem = { config, system, ... }: {
    # _module.args.pkgs = import inputs.nixpkgs {
    #   inherit system;
    #   config.allowUnfree = true;
    #   overlays = [];
    # };
    pkgsDirectory = ../../pkgs/by-name;

    # packages.zen-browser = inputs.zen-browser.packages."${system}".beta;
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
