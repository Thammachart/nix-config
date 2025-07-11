{ pkgs, lib, conditions, templateFile, configData, hostConfig, ...  }:

{
  programs = {
    nushell = {
      enable = true;

      configFile.source = ./config.nu;
      envFile.source = ./env.nu;

      loginFile.source = lib.mkIf conditions.isServer ./login.nu;
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

  xdg.configFile."starship.toml".source = templateFile "starship-${configData.username}" ./starship.toml.tmpl hostConfig.starship;
}
