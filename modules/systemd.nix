{ config, lib, pkgs, ... }:
{
  imports = [
    ./netbird.nix
  ];

  systemd.services."NetworkManager-wait-online".enable = true;

  systemd.user.targets = {
    "user-system-ready" = {
      description = "Custom systemd target to signify system being ready for user";
    };
  };

  systemd.user.services = {
    "lxqt-policykit" = {
      enable = true;
      description = "lxqt-policykit";
      wantedBy = [ "user-system-ready.target" ];

      after = [ "xdg-desktop-portal.service" "polkit.service" "graphical.target" ];

      serviceConfig = {
        Type = "exec";
        ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    "kwalletd" = {
      wantedBy = [ "user-system-ready.target" ];

      after = [ "xdg-desktop-portal.service" "graphical.target" ];

      unitConfig = {
        StartLimitInterval = 5;
      };

      serviceConfig = {
        Type = "exec";
        Restart = "on-failure";
        RestartSec = "1s";
        ExecStart = "${pkgs.kdePackages.kwallet}/bin/kwalletd6";
        # BusName = "org.kde.kwalletd6";
      };
    };

    "nm-applet" = {
      wantedBy = [ "user-system-ready.target" ];

      wants = [ "kwalletd.service" ];
      # requires = [ "NetworkManager.service" ];
      after = [ "xdg-desktop-portal.service" "graphical.target" "kwalletd.service" "NetworkManager.service" ];

      unitConfig = {
        StartLimitInterval = 5;
      };

      serviceConfig = {
        Type = "exec";
        Restart = "on-failure";
        RestartSec = "1s";
        ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
      };
    };
  };
}
