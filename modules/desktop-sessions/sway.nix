{ pkgs, lib, config, ... }:
let
  cmp-customize = import ../../packages/compositor-custom.nix;

  cmp-name = "sway";

  cfg = config.desktop-sessions."${cmp-name}";
  cmp = cmp-customize { inherit pkgs; cmp = cmp-name; };
in
{
  options.desktop-sessions."${cmp-name}" = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    package = lib.mkPackageOption pkgs cmp-name {} // {
      apply =
        p:
        if p == null then
          null
        else
         p.override {
           withBaseWrapper = true;
           withGtkWrapper = true;
           enableXWayland = true;
           isNixOS = true;
         };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ cfg.package swaylock swayidle swaybg grim slurp ];

    services.displayManager.sessionPackages = [ cmp.custom-desktop-entry ];

    environment.etc = {
      "sway/config".source = lib.mkOptionDefault "${cfg.package}/etc/sway/config";
      "sway/config.d/nixos.conf".text = ''
        exec ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
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
