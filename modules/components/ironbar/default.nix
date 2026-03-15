{
  flake.modules.nixos.ironbar = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ ironbar ];
  };

  flake.modules.homeManager.ironbar = { config, osConfig, ... }:
  let
    settings = config.configData.homeSettings // { conditions = osConfig.conditions; };
  in
  {
    home.file.".config/ironbar/hyprland.yaml".source = config.templateFile "ironbar-hyprland-yaml" ./hyprland.yaml.tmpl settings;
    home.file.".config/ironbar/hyprland.css".source = config.templateFile "ironbar-hyprland-css" ./hyprland.css.tmpl settings;
  };
}
