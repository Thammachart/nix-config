{ pkgs, templateFile, configData, isDesktop, ...  }:

{
  imports = [
    ../kanshi
  ];
  home.file.".config/river/variables".source = ./variables;

  wayland.windowManager.river = {
    enable = true;
    extraConfig = builtins.readFile "${templateFile "river-init-${configData.username}" ./init.tmpl configData.homeSettings}";
  };
}
