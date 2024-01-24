{ pkgs, templateFile, homeConfig, isDesktop, ...  }:

let
  settings = homeConfig.homeSettings // { inherit isDesktop; };
in
{
  home.file.".config/waybar/sway.css".source = templateFile "waybar-sway-css-${homeConfig.username}" ./sway.css.tmpl settings;
  home.file.".config/waybar/sway.json".source = templateFile "waybar-sway-json-${homeConfig.username}" ./sway.json.tmpl settings;

  home.file.".config/waybar/hyprland.css".source = templateFile "waybar-hyprland-css-${homeConfig.username}" ./hyprland.css.tmpl settings;
  home.file.".config/waybar/hyprland.json".source = templateFile "waybar-hyprland-json-${homeConfig.username}" ./hyprland.json.tmpl settings;
}
