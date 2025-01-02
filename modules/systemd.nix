{ config, lib, pkgs, conditions, ... }:
{
  imports = [
    ./netbird.nix
  ];

  systemd.services."NetworkManager-wait-online".enable = false;

  systemd.user.targets = {
    "user-system-ready" = {
      description = "Custom systemd target to signify system being ready for user";
    };
  };

  systemd.user.services = {
    "lxqt-policykit" = {
      enable = conditions.graphicalUser;
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
      enable = conditions.graphicalUser;
      wantedBy = [ "user-system-ready.target" ];

      after = [ "xdg-desktop-portal.service" "graphical.target" ];

      aliases = [ "secret-provider.service" ];

      serviceConfig = {
        Type = "dbus";
        Restart = "on-failure";
        RestartSec = 1;
        ExecStart = "${pkgs.kdePackages.kwallet}/bin/kwalletd6";
        ExecStartPost = "${pkgs.libsecret}/bin/secret-tool search att1 val1";
        BusName = "org.freedesktop.secrets";
      };
    };

    "nm-applet" = {
      enable = conditions.graphicalUser;
      wantedBy = [ "user-system-ready.target" ];

      wants = [ "secret-provider.service" ];
      # requires = [ "NetworkManager.service" ];
      after = [ "xdg-desktop-portal.service" "graphical.target" "secret-provider.service" "NetworkManager.service" ];

      serviceConfig = {
        Type = "exec";
        Restart = "on-failure";
        RestartSec = 1;
        ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
      };
    };
  };
}
