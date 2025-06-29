{ pkgs, lib, config, configData, ... }:
let
  providerName = "gnome-keyring";
  cfg = config.secret-providers."${providerName}";
in
{
  options.secret-providers."${providerName}" = {
    enable = lib.mkEnableOption ''
      GNOME Keyring daemon with AGE unlock
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
      owner = "${configData.username}";
      group = "users";
      capabilities = "cap_ipc_lock=ep";
      source = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon";
    };

    systemd.user.services."gnome-keyring-age-unlock" = {
      enable = true;
      wantedBy = [ "user-system-ready.target" ];
      after = [ "polkit.service" "graphical.target" ];

      aliases = [ "secret-provider.service" ];

      serviceConfig = {
        Type = "dbus";
        Restart = "on-failure";
        RestartSec = 1;
        ExecStart = "/bin/sh -c '${pkgs.age}/bin/age -d -i %h/.ssh/id_ed25519 %h/.local/share/keyrings/login.age | exec ${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --foreground --unlock'";
        ExecStartPost = "${pkgs.libsecret}/bin/secret-tool search att1 val1";
        BusName = "org.freedesktop.secrets";
        TimeoutStopSec = 10;
      };
    };
  };
}
