{ inputs, withSystem, ... }:
{
  perSystem = { config, system, ... }: {
    # _module.args.pkgs = import inputs.nixpkgs {
    #   inherit system;
    #   config.allowUnfree = true;
    #   overlays = [];
    # };
    pkgsDirectory = ../../pkgs/by-name;

    packages.zen-browser = inputs.zen-browser.packages."${system}".beta;
    # packages.mcmojave-cursor = inputs.mcmojave-hyprcursor.packages."${system}".default;
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
