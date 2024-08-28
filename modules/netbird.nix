{config, pkgs, nix-secrets, ...}:
let
  name = "netbird-shobshop0";
  pkg = pkgs.netbird;
in
{
  systemd.services."${name}" = let
    environment = {
      NB_INTERFACE_NAME = "wt-${name}";
      NB_CONFIG = "/var/lib/${name}/config.json";
      NB_LOG_FILE = "console";
      NB_WIREGUARD_PORT = 51820;
      NB_DAEMON_ADDR = "unix:///var/run/${name}/sock";
    };
  in
  {
    after = [ "network.target" ];
    wantedBy = [];

    path = with pkgs; [ systemd ];

    inherit environment;

    serviceConfig = {
      EnvironmentFile = config.sops.secrets.shobshop_netbird_env.path;
      ExecStart = "${pkg}/bin/netbird service run";
      Restart = "always";
      RuntimeDirectory = name;
      StateDirectory = name;
      StateDirectoryMode = "0700";
      WorkingDirectory = "/var/lib/${name}";
    };

    unitConfig = {
      StartLimitInterval = 5;
      StartLimitBurst = 10;
    };
  };
}
