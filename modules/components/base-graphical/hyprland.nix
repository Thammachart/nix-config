{
  flake.modules.nixos.base-graphical = { pkgs, config, ... }:
  let
    cmp-name = "hyprland";
    package = pkgs."${cmp-name}";
    cmp = config.wl-cmp { cmp = "Hyprland"; };
  in
  {
    environment.systemPackages = with pkgs; [ package hypridle hyprlock hyprcursor ];

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
