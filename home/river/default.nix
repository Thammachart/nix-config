{ pkgs, osConfig, lib, templateFile, configData, conditions, ...  }:

lib.mkIf osConfig.programs.river.enable {
  home.file.".config/river/variables".source = templateFile "river-variables-${configData.username}" ./variables.tmpl configData.homeSettings;
  home.file.".config/river/autostart".source = templateFile "river-autostart-${configData.username}" ./autostart.tmpl configData.homeSettings;
  home.file.".config/river/inputs".source = templateFile "river-inputs-${configData.username}" ./inputs.tmpl { inherit conditions; };

  wayland.windowManager.river = {
    enable = true;
    extraConfig = builtins.readFile "${templateFile "river-init-${configData.username}" ./init.tmpl configData.homeSettings}";
  };
}
