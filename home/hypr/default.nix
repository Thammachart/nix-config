{ pkgs, config, osConfig, lib, conditions, templateFile, configData, ...  }:

let
  plugins = [ pkgs.hyprlandPlugins.hy3 ];
in
lib.mkIf osConfig.desktop-sessions.hyprland.enable {
  home.file.".config/hypr/hypridle.conf".source = templateFile "hypridle-conf-${configData.username}" ./hypridle.conf.tmpl configData.homeSettings;
  home.file.".config/hypr/hyprlock.conf".source = templateFile "hyprlock-conf-${configData.username}" ./hyprlock.conf.tmpl configData.homeSettings;

  home.file.".config/hypr/variables.conf".source = templateFile "hyprland-vars-${configData.username}" ./variables.conf.tmpl configData.homeSettings;
  home.file.".config/hypr/autostart.conf".source = templateFile "hyprland-autostart-${configData.username}" ./autostart.conf.tmpl configData.homeSettings;
  home.file.".config/hypr/inputs.conf".source = templateFile "hyprland-inputs-${configData.username}" ./inputs.conf.tmpl { inherit conditions; };
  home.file.".config/hypr/binds.conf".source = templateFile "hyprland-binds-${configData.username}" ./binds.conf.tmpl configData.homeSettings;

  home.file.".config/hypr/_init.conf".text = ''
    source = /etc/hyprland/nixos.conf
    env = XCURSOR_THEME,${config.home.pointerCursor.name}
    env = XCURSOR_SIZE,${builtins.toString config.home.pointerCursor.size}
    env = HYPRCURSOR_THEME,${config.home.pointerCursor.name}
    env = HYPRCURSOR_SIZE,${builtins.toString config.home.pointerCursor.size}
    ${lib.concatMapStringsSep "\n" (entry:
      "exec-once = hyprctl plugin load ${entry}/lib/lib${entry.pname}.so"
    ) plugins}
  '';

  home.file.".config/hypr/hyprland.conf".source = templateFile "hyprland-config-${configData.username}" ./hyprland.conf.tmpl configData.homeSettings;

  ### NixOS options make xdg-desktop-portal-hyprland conflict with other variants
  # wayland.windowManager.hyprland =
  #   enable = true;
  # };
}
