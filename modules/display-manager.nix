{ pkgs, sway-custom, config, ... }:
let
  sway-custom = import ../packages/sway-custom.nix { inherit pkgs; };
  desktopSessions = config.services.displayManager.sessionData.desktops;
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember-session --user-menu --sessions ${desktopSessions}/share/wayland-sessions";
        user = "greeter";
      };
    };
  };

  services.displayManager = {
    enable = true;
    execCmd = config.systemd.services.greetd.serviceConfig.ExecStart;
    sessionPackages = [ sway-custom.sway-custom-desktop-entry ];
  };
}
