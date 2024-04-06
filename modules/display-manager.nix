{ pkgs, sway-custom, config, ... }:
let
  sway-custom = import ../packages/sway-custom.nix { inherit pkgs; };
  hyprland-custom = import ../packages/hyprland-custom.nix { inherit pkgs; };
  desktopSessions = config.services.xserver.displayManager.sessionData.desktops;
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

  services.xserver.displayManager.sessionPackages = [ sway-custom.sway-custom-desktop-entry hyprland-custom.hyprland-custom-desktop-entry ];
  security.pam.services.greetd = {
    enableGnomeKeyring = true;
  };
}
