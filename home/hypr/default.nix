{ pkgs, templateFile, configData, isDesktop, hy3, ...  }:

{
  home.file.".config/hypr/variables.conf".source = templateFile "hyprland-vars-${configData.username}" ./variables.conf.tmpl configData.homeSettings;
  home.file.".config/hypr/autostart.conf".source = templateFile "hyprland-autostart-${configData.username}" ./autostart.conf.tmpl configData.homeSettings;

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile "${templateFile "hyprland-config-${configData.username}" ./hyprland.conf.tmpl {}}";
    plugins = [ pkgs.hyprlandPlugins.hy3 ];
  };
}
