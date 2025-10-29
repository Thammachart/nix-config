{ inputs, withSystem, ... }:
{
  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config = {
        # allowUnfreePredicate = pkg: true;
        allowUnfree = true;
      };
      overlays = [];
    };
    pkgsDirectory = ../../pkgs/by-name;
  };
}
