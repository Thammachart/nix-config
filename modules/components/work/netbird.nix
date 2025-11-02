{
  flake.modules.nixos.work = { pkgs, lib, config, ... }:
  let
    providerName = "shobshop0";
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
        clients."${providerName}" = {
          port = 51820;
        };
      };

      systemd.services.netbird.wantedBy = if (!cfg.netbird.autostart) then lib.mkForce [] else [];
    };
  };
}
