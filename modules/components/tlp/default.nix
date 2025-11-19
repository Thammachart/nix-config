{
  flake.modules.nixos.tlp = { pkgs, lib, config, ... }: {
    services.tlp = {
      enable = true;
      package = pkgs.tlp;
      settings = {} // lib.optionals (config.conditions.isLaptop) {
        START_CHARGE_THRESH_BAT0 = 30;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
  };
}
