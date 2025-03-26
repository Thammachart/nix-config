{ pkgs, lib, config, conditions, configData, ... }:
let
  cmp-customize = import ../packages/compositor-custom.nix;
  desktopSessions = config.services.displayManager.sessionData.desktops;

  compositor = cmp-customize { inherit pkgs; cmp = "sway"; };
in
lib.mkIf conditions.graphicalUser {
  services.greetd = {
    enable = true;
    settings = {
      # default_session = {
      #   command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember-session --user-menu --sessions ${desktopSessions}/share/wayland-sessions";
      #   user = "greeter";
      # };

      # initial_session = lib.mkIf (!conditions.isDesktop) {
      #   command = "${compositor.launch}/bin/launch";
      #   user = configData.username;
      # };
    };
  };

  services.displayManager = {
    enable = true;
    execCmd = config.systemd.services.greetd.serviceConfig.ExecStart;
    sessionPackages = [ compositor.custom-desktop-entry ];
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
