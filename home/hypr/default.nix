{ pkgs, templateFile, configData, isDesktop, hy3, ...  }:

{
  home.file.".config/hypr/hyprland.conf".source = templateFile "hyprland-config-${configData.username}" ./hyprland.conf.tmpl { inherit hy3; };
  home.file.".config/hypr/variables.conf".source = templateFile "hyprland-vars-${configData.username}" ./variables.conf.tmpl configData.homeSettings;
  home.file.".config/hypr/autostart.conf".source = templateFile "hyprland-autostart-${configData.username}" ./autostart.conf.tmpl configData.homeSettings;
}
