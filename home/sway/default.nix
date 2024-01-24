{ pkgs, templateFile, homeConfig, isDesktop, ...  }:

{
  home.file.".config/sway/config".source = ./config;
  home.file.".config/sway/variables".source = templateFile "sway-vars-${homeConfig.username}" ./variables.tmpl homeConfig.homeSettings;
  home.file.".config/sway/autostart".source = templateFile "sway-autostart-${homeConfig.username}" ./autostart.tmpl homeConfig.homeSettings;
  home.file.".config/sway/inputs".source = templateFile "sway-inputs-${homeConfig.username}" ./inputs.tmpl { isDesktop = isDesktop; };
  home.file.".config/sway/theme".source = ./theme;
}
