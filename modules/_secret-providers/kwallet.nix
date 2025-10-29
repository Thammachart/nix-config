{ pkgs, lib, config, configData, ... }:
let
  providerName = "kwallet";
  cfg = config.secret-providers."${providerName}";
in
{
  options.secret-providers."${providerName}" = {
    enable = lib.mkEnableOption ''
      KWallet daemon
    '';
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.kdePackages.kwallet
      pkgs.kdePackages.kwalletmanager
    ];

    # services.dbus.packages = [
    #   pkgs.kdePackages.kwallet
    # ];

    # xdg.portal.extraPortals = [];

    # security.pam.services.login.kwallet = {
    #   enable = true;
    # };

    systemd.user.services."kwalletd" = {
      enable = true;
      wantedBy = [ "user-system-ready.target" ];

      after = [ "xdg-desktop-portal.service" "polkit.service" "graphical.target" ];

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
  };
}
