{
  flake.modules.nixos.work = { pkgs, ... }:
  let
    name = "shobshop0";
  in
  {
    environment.systemPackages = [ pkgs.netbird ];

    services.netbird = {
      ui.enable = false;
      clients = {
        "${name}" = {
          port = 51820;
        };
      };
    };

    systemd.services."netbird-${name}".wantedBy = [];
  };
}
