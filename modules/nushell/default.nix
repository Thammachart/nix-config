{ lib, ... }:
{
  flake.modules.homeManager.nushell = { pkgs, config, configData, hostConfig, ... }: {
    programs = {
      nushell = {
        enable = true;

        configFile.source = ./config.nu;
        envFile.source = ./env.nu;

        loginFile.source = ./login.nu;
      };

      starship = {
        enable = true;
        enableNushellIntegration = true;
      };

      carapace = {
        enable = true;
        enableNushellIntegration = true;
      };
    };

    xdg.configFile."starship.toml".source = config.util.templateFile "starship" ./starship.toml.tmpl hostConfig.starship;
  };
}
