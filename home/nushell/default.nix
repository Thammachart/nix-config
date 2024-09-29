{ pkgs, lib, conditions, templateFile, configData, ...  }:

{
  programs = {
    nushell = {
      enable = true;

      configFile.source = ./config.nu;
      envFile.source = ./env.nu;

      loginFile = lib.mkIf conditions.isServer ''
        if (tty) == "/dev/tty1" {
          setterm -blank 5
        }
      '';

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

  xdg.configFile."starship.toml".source = ./starship.toml;
}
