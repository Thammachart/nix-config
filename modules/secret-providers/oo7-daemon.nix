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
    environment.systemPackages = [ pkgs.oo7 pkgs.oo7-server ];

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
        ExecStart = "+/bin/sh -c '${pkgs.age}/bin/age -d -i ~/.ssh/id_ed25519 ~/.local/share/keyrings/login.age | ${pkgs.oo7-server}/libexec/oo7-daemon --login'";
        ExecStartPost = "${pkgs.libsecret}/bin/secret-tool search att1 val1";
        BusName = "org.freedesktop.secrets";
        TimeoutStopSec = 10;
      };
    };
  };
}
