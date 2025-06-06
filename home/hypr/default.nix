{ pkgs, osConfig, lib, conditions, templateFile, configData, ...  }:

let
  plugins = [ pkgs.hyprlandPlugins.hy3 ];
in
lib.mkIf conditions.hyprland {
  home.file.".config/hypr/hypridle.conf".source = templateFile "hypridle-conf-${configData.username}" ./hypridle.conf.tmpl configData.homeSettings;
  home.file.".config/hypr/hyprlock.conf".source = templateFile "hyprlock-conf-${configData.username}" ./hyprlock.conf.tmpl configData.homeSettings;

  home.file.".config/hypr/variables.conf".source = templateFile "hyprland-vars-${configData.username}" ./variables.conf.tmpl configData.homeSettings;
  home.file.".config/hypr/autostart.conf".source = templateFile "hyprland-autostart-${configData.username}" ./autostart.conf.tmpl configData.homeSettings;
  home.file.".config/hypr/inputs.conf".source = templateFile "hyprland-inputs-${configData.username}" ./inputs.conf.tmpl { inherit conditions; };
  home.file.".config/hypr/binds.conf".source = templateFile "hyprland-binds-${configData.username}" ./binds.conf.tmpl configData.homeSettings;

  home.file.".config/hypr/_init.conf".text = ''
    exec-once = ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    ${lib.concatMapStringsSep "\n" (entry:
      "exec-once = hyprctl plugin load ${entry}/lib/lib${entry.pname}.so"
    ) plugins}
  '';

  home.file.".config/hypr/hyprland.conf".source = templateFile "hyprland-config-${configData.username}" ./hyprland.conf.tmpl configData.homeSettings;

  ## NixOS options make xdg-desktop-portal-hyprland conflict with other variant
  # wayland.windowManager.hyprland =
  #   enable = true;
  # };
}
