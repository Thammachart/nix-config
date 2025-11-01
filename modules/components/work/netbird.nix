{
  flake.modules.nixos.work = { pkgs, lib, config, ... }:
  let
    cfg = config.work;
  in
  {
    options.work.netbird = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      autostart = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };

    config = lib.mkIf cfg.netbird.enable {
      environment.systemPackages = [ pkgs.netbird ];

      services.netbird = {
        ui.enable = false;
      };

      systemd.services.netbird.wantedBy = if (!cfg.netbird.autostart) then lib.mkForce [] else [];
    };
  };
}
