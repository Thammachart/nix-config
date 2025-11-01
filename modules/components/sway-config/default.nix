{
  flake.modules.homeManager.sway-config = { pkgs, lib, config, ... }: {
    home.file.".config/sway/config".source = ./config;
    home.file.".config/sway/variables".source = config.templateFile "sway-vars" ./variables.tmpl config.configData.homeSettings;
    home.file.".config/sway/autostart".source = config.templateFile "sway-autostart" ./autostart.tmpl (config.configData.homeSettings // { pointerTheme = config.home.pointerCursor.name; pointerSize = config.home.pointerCursor.size; });
    home.file.".config/sway/inputs".source = config.templateFile "sway-inputs" ./inputs.tmpl { inherit conditions; };
    home.file.".config/sway/theme".source = ./theme;
    # home.file.".config/sway/status.sh".source = ./status.sh;
  };
}
