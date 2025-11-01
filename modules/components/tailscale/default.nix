{ lib, ... }:
{
  flake.modules.nixos.tailscale = { pkgs, config, hostname, ... }:
  let
    cfg = config.tailscale;
  in
  {
    options.tailscale = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      autostart = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };

    config = lib.mkIf cfg.enable {
      services.tailscale = {
        enable = true;
      };

      systemd.services.tailscaled.wantedBy = if (!cfg.autostart) then lib.mkForce [] else [];
    };
  };
}
