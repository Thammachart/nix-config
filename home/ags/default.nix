{ pkgs, templateFile, configData, isDesktop, ...  }:

{
  home.file.".config/ags/config.js".source = ./config.js;
  home.file.".config/ags/style.css".source = ./style.css;
}
