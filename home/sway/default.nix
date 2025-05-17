{ pkgs, osConfig, lib, templateFile, configData, conditions, ...  }:

lib.mkIf osConfig.programs.sway.enable {
  home.file.".config/sway/config".source = ./config;
  home.file.".config/sway/variables".source = templateFile "sway-vars-${configData.username}" ./variables.tmpl configData.homeSettings;
  home.file.".config/sway/autostart".source = templateFile "sway-autostart-${configData.username}" ./autostart.tmpl configData.homeSettings;
  home.file.".config/sway/inputs".source = templateFile "sway-inputs-${configData.username}" ./inputs.tmpl { inherit conditions; };
  home.file.".config/sway/theme".source = ./theme;
  # home.file.".config/sway/status.sh".source = ./status.sh;
}
