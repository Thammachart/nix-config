
{ pkgs, templateFile, isDesktop, configData, ...  }:

{
  programs.nushell = {
    enable = true;

    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };

  xdg.configFile."starship.toml".source = ./starship.toml;
}
