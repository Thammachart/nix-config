{ lib, ... }:
{
  flake.modules.nixos.nushell = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ nushell ];
  };

  flake.modules.homeManager.nushell = { pkgs, config, hostConfig, ... }:
  {
    programs = {
      nushell = {
        enable = true;
        package = null;

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

    xdg.configFile."starship.toml".source = config.templateFile "starship" ./starship.toml.tmpl hostConfig.starship;
  };
}
