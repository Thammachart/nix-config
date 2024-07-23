{ pkgs, sway-custom, config, configData, ... }:
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
      
      initial_session = {
        command = "${sway-custom.launch-sway}/bin/launch-sway";
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
