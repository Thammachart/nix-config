{ pkgs, templateFile, configData, isDesktop, ...  }:

{
  home.file.".config/river/variables".source = ./variables;
  home.file.".config/river/autostart".source = ./autostart;
  home.file.".config/river/inputs".source = templateFile "river-inputs-${configData.username}" ./inputs.tmpl { isDesktop = isDesktop; };

  wayland.windowManager.river = {
    enable = true;
    extraConfig = builtins.readFile "${templateFile "river-init-${configData.username}" ./init.tmpl configData.homeSettings}";
  };
}
