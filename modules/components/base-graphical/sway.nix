{
  flake.modules.nixos.base-graphical = { pkgs, lib, config, ... }:
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
}
