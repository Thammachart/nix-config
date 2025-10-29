{ config, lib, pkgs, conditions, ... }:
{
  systemd.user.services = {
    # "lxqt-policykit" = {
    #   enable = conditions.graphicalUser;
    #   wantedBy = [ "user-system-ready.target" ];

    #   after = [ "xdg-desktop-portal.service" "polkit.service" "graphical.target" ];

    #   serviceConfig = {
    #     Type = "exec";
    #     ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
    #     Restart = "on-failure";
    #     RestartSec = 1;
    #     TimeoutStopSec = 10;
    #   };
    # };

    "polkit-kde-agent" = {
      enable = conditions.graphicalUser;
      wantedBy = [ "user-system-ready.target" ];

      after = [ "xdg-desktop-portal.service" "polkit.service" "graphical.target" ];

      serviceConfig = {
        Type = "exec";
        ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
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
