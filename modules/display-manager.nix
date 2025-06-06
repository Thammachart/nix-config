{ pkgs, lib, config, conditions, configData, ... }:
let
  # cmp-customize = import ../packages/compositor-custom.nix;
  # desktopSessions = config.services.displayManager.sessionData.desktops;
  #
  # sway = cmp-customize { inherit pkgs; cmp = "sway"; };
  # hyprland = cmp-customize { inherit pkgs; cmp = "Hyprland"; };
in
lib.mkIf conditions.graphicalUser {
  services.greetd = {
    enable = true;
    settings = {
      # default_session = {
      #   command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember-session --user-menu --sessions ${desktopSessions}/share/wayland-sessions";
      #   user = "greeter";
      # };

      # initial_session = {
      #   command = "${compositor.launch}/bin/launch";
      #   user = configData.username;
      # };
    };
  };

  services.displayManager = {
    enable = true;
    execCmd = config.systemd.services.greetd.serviceConfig.ExecStart;
  };

  programs.regreet = {
    enable = true;
    font = {
      name = "Adwaita Sans";
      package = pkgs.adwaita-fonts;
    };
    settings = {
      GTK = {
        application_prefer_dark_theme = true;
      };
    };
  };
}
