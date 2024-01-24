{ pkgs, templateFile, homeConfig, isDesktop, ...  }:

{
  home.file.".config/waybar/sway.css".source = templateFile "waybar-sway-css-${homeConfig.username}" ./sway.css.tmpl homeConfig.homeSettings;
  home.file.".config/waybar/sway.json".source = templateFile "waybar-sway-json-${homeConfig.username}" ./sway.json.tmpl homeConfig.homeSettings;

  home.file.".config/waybar/hyprland.css".source = templateFile "waybar-hyprland-css-${homeConfig.username}" ./hyprland.css.tmpl homeConfig.homeSettings;
  home.file.".config/waybar/hyprland.json".source = templateFile "waybar-hyprland-json-${homeConfig.username}" ./hyprland.json.tmpl homeConfig.homeSettings;
}
