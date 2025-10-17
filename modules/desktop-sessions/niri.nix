{pkgs, lib, config, ...}:
let
  cmp-customize = import ../../packages/compositor-custom.nix;

  cmp-name = "niri";

  cfg = config.desktop-sessions."${cmp-name}";
  cmp = cmp-customize { inherit pkgs; inherit config; cmp = cmp-name; cmp-exec = "niri --session"; };
in
{
  options.desktop-sessions."${cmp-name}" = {
    enable = lib.mkEnableOption ''${cmp-name}'';

    package = lib.mkPackageOption pkgs cmp-name {};
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ cfg.package xwayland-satellite ];

    services.displayManager.sessionPackages = [ cmp.custom-desktop-entry ];

    security = {
      polkit.enable = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      config = {
        "${cmp-name}" = {
          default = [ "gnome" ];
          # "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          # "org.freedesktop.impl.portal.Secret" = [ "oo7-portal" ];
        };
      };
    };
  };
}
