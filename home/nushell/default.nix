
{ pkgs, templateFile, isDesktop, configData, ...  }:

{
  home.file.".config/nushell/config.nu".source = ./config.nu;
  home.file.".config/nushell/env.nu".source = ./env.nu;
}
