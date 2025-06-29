{ pkgs, lib, config, ... }:
let
  providerName = "oo7-daemon";
  cfg = config.secret-providers."${providerName}";
in
{
  options.secret-providers."${providerName}" = {
    enable = lib.mkEnableOption ''
      oo7 daemon
    '';
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.oo7 ];

    services.dbus.packages = [];

    # xdg.portal.extraPortals = [ pkgs.oo7-portal ];

    systemd.user.services."oo7-daemon" = {
      enable = true;
      wantedBy = [ "user-system-ready.target" ];
      after = [ "polkit.service" "graphical.target" ];

      aliases = [ "secret-provider.service" ];

      serviceConfig = {
        Type = "dbus";
        Restart = "on-failure";
        RestartSec = 1;
        ExecStart = "${pkgs.oo7-server}/bin/oo7-daemon --verbose --replace --login";
        ExecStartPost = "${pkgs.libsecret}/bin/secret-tool search att1 val1";
        BusName = "org.freedesktop.secrets";
        TimeoutStopSec = 10;
      };
    };
  };
}
