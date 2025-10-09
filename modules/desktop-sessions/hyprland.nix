{pkgs, lib, config, ...}:
let
  cmp-customize = import ../../packages/compositor-custom.nix;

  cmp-name = "hyprland";

  cfg = config.desktop-sessions."${cmp-name}";
  cmp = cmp-customize { inherit pkgs; inherit config; cmp = "Hyprland"; };
in
{
  options.desktop-sessions."${cmp-name}" = {
    enable = lib.mkEnableOption ''${cmp-name}'';

    package = lib.mkPackageOption pkgs cmp-name {};
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ cfg.package hypridle hyprlock hyprcursor ];

    services.displayManager.sessionPackages = [ cmp.custom-desktop-entry ];

    environment.etc."hyprland/nixos.conf".text = ''
      exec-once = ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    '';

    security = {
      polkit.enable = true;
      pam.services.hyprlock = {};
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];
      config = {
        "${cmp-name}" = {
          default = [ "hyprland" "gtk" ];
          # "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          # "org.freedesktop.impl.portal.Secret" = [ "oo7-portal" ];
        };
      };
    };
  };
}
