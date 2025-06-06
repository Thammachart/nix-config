{pkgs, lib, ...}:
let
  cmp-customize = import ../../packages/compositor-custom.nix;
  cfg = config.desktop-sessions.hyprland;

  cmp = cmp-customize { inherit pkgs; cmp = "Hyprland"; };
in
{
  options.desktop-sessions.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ hyprland ];

    services.displayManager.sessionPackages = [ cmp.custom-desktop-entry ];

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];
      config = {
        hyprland = {
          default = [ "hyprland" "gtk" ];
          # "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          # "org.freedesktop.impl.portal.Secret" = [ "oo7-portal" ];
        };
      };
    };
  };
}
