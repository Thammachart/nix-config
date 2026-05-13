{
  flake.modules.nixos.base-graphical = { pkgs, config, ... }:
  let
    desktopSessions = config.services.displayManager.sessionData.desktops;
  in
  {
    services.greetd = {
      enable = true;
      useTextGreeter = true;

      settings = {
        # default_session = {
        #   command = "${pkgs.greetd}/bin/agreety --cmd sway";
        # };
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember-session --user-menu --sessions ${desktopSessions}/share/wayland-sessions";
          user = "greeter";
        };

        # initial_session = {
        #   command = "${compositor.launch}/bin/launch";
        #   user = configData.username;
        # };
      };
    };

    # services.displayManager = {
    #   enable = true;
    #   execCmd = config.systemd.services.greetd.serviceConfig.ExecStart;
    # };

    programs.regreet = {
      enable = false;
      cageArgs = [ "-s" "-d" "-m" "last" ];

      font = {
        name = "Ubuntu Sans";
        package = pkgs.ubuntu-sans;
      };
      settings = {
        GTK = {
          application_prefer_dark_theme = true;
        };
      };
    };
  };
}
