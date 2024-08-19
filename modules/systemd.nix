{ config, lib, pkgs }:
{
  systemd.services.NetworkManager-wait-online.enable = false;

  systemd.user.services = {
    lxqt-policykit = {
      enable = true;
      description = "lxqt-policykit";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  systemd.services."netbird-shobshop0" = {
    wantedBy = lib.mkForce [];
  };

  systemd.user.services = {
    "kwalletd" = {
      wantedBy = [ "default.target" ];
      after = [ "graphical.target" ];

      unitConfig = {
        ConditionEnvironment = "DISPLAY";
        StartLimitInterval = 5;
      };

      serviceConfig = {
        Type = "exec";
        Restart = "on-failure";
        RestartSec = "2s";
        ExecStart = "${pkgs.kdePackages.kwallet}/bin/kwalletd6";
        # BusName = "org.kde.kwalletd6";
      };
    };

    "nm-applet" = {
      wantedBy = [ "default.target" ];
      upholds = [ "kwalletd.service" "NetworkManager.service" ];
      after = [ "graphical.target" "kwalletd.service" "NetworkManager.service" ];

      unitConfig = {
        ConditionEnvironment = "DISPLAY";
        StartLimitInterval = 5;
      };

      serviceConfig = {
        Type = "exec";
        Restart = "on-failure";
        RestartSec = "2s";
        ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
      };
    };
  };
}
