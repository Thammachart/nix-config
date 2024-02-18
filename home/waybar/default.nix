{ pkgs, templateFile, configData, isDesktop, ...  }:

let
  settings = configData.homeSettings // { inherit isDesktop; };
in
{
  home.file.".config/waybar/sway.css".source = templateFile "waybar-sway-css-${configData.username}" ./sway.css.tmpl settings;
  home.file.".config/waybar/sway.json".source = templateFile "waybar-sway-json-${configData.username}" ./sway.json.tmpl settings;

  home.file.".config/waybar/hyprland.css".source = templateFile "waybar-hyprland-css-${configData.username}" ./hyprland.css.tmpl settings;
  home.file.".config/waybar/hyprland.json".source = templateFile "waybar-hyprland-json-${configData.username}" ./hyprland.json.tmpl settings;
}
