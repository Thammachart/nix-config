{config, lib, pkgs, nix-secrets, conditions, ...}:
let
  name = "shobshop0";
in
lib.mkIf conditions.netbird {
  services.netbird.clients = {
    "${name}" = {
      port = 51820;
    };
  };
  systemd.services."netbird-${name}".wantedBy = [];
}
