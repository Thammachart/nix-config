{ pkgs, templateFile, configData, isDesktop, ...  }:

{
  home.file.".config/sway/config".source = ./config;
  home.file.".config/sway/variables".source = templateFile "sway-vars-${configData.username}" ./variables.tmpl configData.homeSettings;
  home.file.".config/sway/autostart".source = templateFile "sway-autostart-${configData.username}" ./autostart.tmpl configData.homeSettings;
  home.file.".config/sway/inputs".source = templateFile "sway-inputs-${configData.username}" ./inputs.tmpl { isDesktop = isDesktop; };
  home.file.".config/sway/theme".source = ./theme;
  home.file.".config/sway/status.sh".source = ./status.sh;
}
