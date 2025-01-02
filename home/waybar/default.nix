{ pkgs, lib, templateFile, configData, conditions, ...  }:

let
  settings = configData.homeSettings // { inherit conditions; };
in
lib.mkIf conditions.graphicalUser {
  home.file.".config/waybar/global.jsonc".source = templateFile "waybar-global-jsonc-${configData.username}" ./global.jsonc.tmpl settings;

  home.file.".config/waybar/sway.css".source = templateFile "waybar-sway-css-${configData.username}" ./sway.css.tmpl settings;
  home.file.".config/waybar/sway.json".source = templateFile "waybar-sway-json-${configData.username}" ./sway.json.tmpl settings;

  home.file.".config/waybar/hyprland.css".source = templateFile "waybar-hyprland-css-${configData.username}" ./hyprland.css.tmpl settings;
  home.file.".config/waybar/hyprland.json".source = templateFile "waybar-hyprland-json-${configData.username}" ./hyprland.json.tmpl settings;

  home.file.".config/waybar/river.css".source = templateFile "waybar-river-css-${configData.username}" ./river.css.tmpl settings;
  home.file.".config/waybar/river.json".source = templateFile "waybar-river-json-${configData.username}" ./river.json.tmpl settings;
}
