{ pkgs, lib, config, ... }:
let
  providerName = "gnome-keyring";
in
{
  options.secret-provider."${providerName}" = {
    enable = lib.mkEnableOption ''
      GNOME Keyring daemon with GPG unlock
    '';
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnome-keyring ];

    services.dbus.packages = [
      pkgs.gnome-keyring
      pkgs.gcr
    ];

    xdg.portal.extraPortals = [ pkgs.gnome-keyring ];

    # security.pam.services.login.enableGnomeKeyring = true;

    security.wrappers.gnome-keyring-daemon = {
      owner = "root";
      group = "root";
      capabilities = "cap_ipc_lock=ep";
      source = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon";
    };

    systemd.users.services."gnome-keyring-gpg-unlock" = {
      enable = conditions.graphicalUser;
      wantedBy = [ "user-system-ready.target" ];
      after = [ "polkit.service" "graphical.target" ];

      aliases = [ "secret-provider.service" ];

      serviceConfig = {
        Type = "dbus";
        Restart = "on-failure";
        RestartSec = 1;
        ExecStart = "/bin/sh -c 'gpg -q --decrypt --armor ~/.local/share/keyrings/login.asc | ${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --foreground --unlock'";
        ExecStartPost = "${pkgs.libsecret}/bin/secret-tool search att1 val1";
        BusName = "org.freedesktop.secrets";
        TimeoutStopSec = 10;
      };
    };
  };
}
