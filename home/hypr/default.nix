{ pkgs, osConfig, lib, conditions, templateFile, configData, ...  }:

lib.mkIf osConfig.programs.hyprland.enable {
  home.file.".config/hypr/hypridle.conf".source = templateFile "hypridle-conf-${configData.username}" ./hypridle.conf.tmpl configData.homeSettings;
  home.file.".config/hypr/hyprlock.conf".source = templateFile "hyprlock-conf-${configData.username}" ./hyprlock.conf.tmpl configData.homeSettings;

  home.file.".config/hypr/variables.conf".source = templateFile "hyprland-vars-${configData.username}" ./variables.conf.tmpl configData.homeSettings;
  home.file.".config/hypr/autostart.conf".source = templateFile "hyprland-autostart-${configData.username}" ./autostart.conf.tmpl configData.homeSettings;
  home.file.".config/hypr/inputs.conf".source = templateFile "hyprland-inputs-${configData.username}" ./inputs.conf.tmpl { inherit conditions; };
  home.file.".config/hypr/binds.conf".source = templateFile "hyprland-binds-${configData.username}" ./binds.conf.tmpl configData.homeSettings;
  #
  #home.file.".config/hypr/monitors.conf".text = "";
  #home.file.".config/hypr/workspaces.conf".text = "";

  wayland.windowManager.hyprland = {
    enable = true;
    # sourceFirst = false;
    extraConfig = builtins.readFile "${templateFile "hyprland-config-${configData.username}" ./hyprland.conf.tmpl configData.homeSettings}";
    plugins = [ pkgs.hyprlandPlugins.hy3 ];
  };
}
