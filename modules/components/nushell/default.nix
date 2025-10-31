{ lib, config, ... }:
{
  flake.modules.homeManager.nushell = { pkgs, hostConfig, ... }:
  let
    utils = config.utils { inherit pkgs; };
  in
  {
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

    xdg.configFile."starship.toml".source = utils.templateFile "starship" ./starship.toml.tmpl hostConfig.starship;
  };
}
