{
  flake.modules.nixos.tlp = { pkgs, lib, config, ... }: {
    services.tlp = {
      enable = true;
      package = pkgs.tlp;
      settings = {} // lib.optionals (config.conditions.isLaptop) {
        # ThinkPad
        START_CHARGE_THRESH_BAT0 = 30;
        STOP_CHARGE_THRESH_BAT0 = 80;

        # Asus
        START_CHARGE_THRESH_BATT = 30;
        STOP_CHARGE_THRESH_BATT = 80;
      };
    };
  };
}
