{
  flake.modules.nixos.waybar = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ waybar ];
  };

  flake.modules.homeManager.waybar = { config, osConfig, ... }:
  let
    settings = config.configData.homeSettings // { conditions = osConfig.conditions; };
  in
  {
    home.file.".config/waybar/global.jsonc".source = config.templateFile "waybar-global-jsonc" ./global.jsonc.tmpl settings;
    home.file.".config/waybar/colors/everforest.css".source = ./colors/everforest.css;
    home.file.".config/waybar/colors/everforest-light.css".source = ./colors/everforest-light.css;

    home.file.".config/waybar/sway.css".source = config.templateFile "waybar-sway-css" ./sway.css.tmpl settings;
    home.file.".config/waybar/sway.json".source = config.templateFile "waybar-sway-json" ./sway.json.tmpl settings;

    home.file.".config/waybar/hyprland.css".source = config.templateFile "waybar-hyprland-css" ./hyprland.css.tmpl settings;
    home.file.".config/waybar/hyprland.json".source = config.templateFile "waybar-hyprland-json" ./hyprland.json.tmpl settings;

    home.file.".config/waybar/river.css".source = config.templateFile "waybar-river-css" ./river.css.tmpl settings;
    home.file.".config/waybar/river.json".source = config.templateFile "waybar-river-json" ./river.json.tmpl settings;

    home.file.".config/waybar/niri.css".source = config.templateFile "waybar-niri-css" ./niri.css.tmpl settings;
    home.file.".config/waybar/niri.json".source = config.templateFile "waybar-niri-json" ./niri.json.tmpl settings;
  };
}
