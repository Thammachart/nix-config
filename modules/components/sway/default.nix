{
  flake.modules.nixos.sway = { pkgs, lib, config, ... }:
  let
    cmp-name = "sway";
    package = pkgs."${cmp-name}".override {
      withBaseWrapper = true;
      withGtkWrapper = true;
      enableXWayland = true;
      isNixOS = true;
    };
    cmp = config.wl-cmp { cmp = cmp-name; };
  in
  {
    environment.systemPackages = with pkgs; [ package swaylock swayidle swaybg grim slurp ];

    services.displayManager.sessionPackages = [ cmp.custom-desktop-entry ];

    environment.etc = {
      "sway/config".source = lib.mkOptionDefault "${package}/etc/sway/config";
      "sway/config.d/nixos.conf".text = ''
        exec ${config.services.dbus.dbusPackage}/bin/dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
      '';
    };

    security = {
      polkit.enable = true;
      pam.services.swaylock = {};
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      wlr = {
        enable = true;
        settings = {};
      };
      config = {
        "${cmp-name}" = {
          default = [ "wlr" "gtk" ];
          "org.freedesktop.impl.portal.ScreenCast" = "wlr";
          "org.freedesktop.impl.portal.Screenshot" = "wlr";
        };
      };
    };
  };

  flake.modules.homeManager.sway = { lib, config, ... }: {
    home.file.".config/sway/config".source = ./config;
    home.file.".config/sway/variables".source = config.templateFile "sway-vars" ./variables.tmpl config.configData.homeSettings;
    home.file.".config/sway/autostart".source = config.templateFile "sway-autostart" ./autostart.tmpl (config.configData.homeSettings // { pointerTheme = config.home.pointerCursor.name; pointerSize = config.home.pointerCursor.size; });
    home.file.".config/sway/inputs".source = config.templateFile "sway-inputs" ./inputs.tmpl {};
    home.file.".config/sway/theme".source = ./theme;
    # home.file.".config/sway/status.sh".source = ./status.sh;
  };
}
