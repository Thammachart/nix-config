{
  flake.modules.homeManager.hyprland = { pkgs, config, osConfig, ... }:
  let
    plugins = [ pkgs.hyprlandPlugins.hy3 ];
  in
  {
    home.file.".config/hypr/hypridle.conf".source = config.templateFile "hypridle-conf" ./hypridle.conf.tmpl config.configData.homeSettings;
    home.file.".config/hypr/hyprlock.conf".source = config.templateFile "hyprlock-conf" ./hyprlock.conf.tmpl config.configData.homeSettings;

    home.file.".config/hypr/variables.conf".source = config.templateFile "hyprland-vars" ./variables.conf.tmpl config.configData.homeSettings;
    home.file.".config/hypr/autostart.conf".source = config.templateFile "hyprland-autostart" ./autostart.conf.tmpl config.configData.homeSettings;
    home.file.".config/hypr/inputs.conf".source = config.templateFile "hyprland-inputs" ./inputs.conf.tmpl { inherit (osConfig) conditions; };
    home.file.".config/hypr/binds.conf".source = config.templateFile "hyprland-binds" ./binds.conf.tmpl config.configData.homeSettings;

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

    home.file.".config/hypr/hyprland.conf".source = config.templateFile "hyprland-config" ./hyprland.conf.tmpl configData.homeSettings;

    ### NixOS options make xdg-desktop-portal-hyprland conflict with other variants
    # wayland.windowManager.hyprland =
    #   enable = true;
    # };
  };
}
