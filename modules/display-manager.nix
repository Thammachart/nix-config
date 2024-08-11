{ pkgs, config, configData, ... }:
let
  cmp-custom = import ../packages/compositor-custom.nix;
  desktopSessions = config.services.displayManager.sessionData.desktops;

  cmp = cmp-custom { pkgs = pkgs: cmp = "river"};
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember-session --user-menu --sessions ${desktopSessions}/share/wayland-sessions";
        user = "greeter";
      };

      initial_session = {
        command = "${cmp-custom.launch}/bin/launch";
        user = configData.username;
      };
    };
  };

  services.displayManager = {
    enable = true;
    execCmd = config.systemd.services.greetd.serviceConfig.ExecStart;
    sessionPackages = [ sway-custom.sway-custom-desktop-entry ];
  };
}
