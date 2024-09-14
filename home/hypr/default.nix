{ pkgs, templateFile, configData, ...  }:

{
  home.file.".config/hypr/variables.conf".source = templateFile "hyprland-vars-${configData.username}" ./variables.conf.tmpl configData.homeSettings;
  home.file.".config/hypr/autostart.conf".source = templateFile "hyprland-autostart-${configData.username}" ./autostart.conf.tmpl configData.homeSettings;
  #home.file.".config/hypr/hyprland.conf".source = templateFile "hyprland-config-${configData.username}" ./hyprland.conf.tmpl configData.homeSettings;
  #home.file.".config/hypr/monitors.conf".text = "";
  #home.file.".config/hypr/workspaces.conf".text = "";

  wayland.windowManager.hyprland = {
    enable = true;
    # sourceFirst = false;
    extraConfig = builtins.readFile "${templateFile "hyprland-config-${configData.username}" ./hyprland.conf.tmpl configData.homeSettings}";
    plugins = [ pkgs.hyprlandPlugins.hy3 ];
  };
}
