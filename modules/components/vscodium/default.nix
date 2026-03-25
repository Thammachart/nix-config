{
  flake.modules.nixos.vscodium = { pkgs, ... }: {
  };

  flake.modules.homeManager.vscodium = { inputs, pkgs, config, configData, ... }: {
    programs.vscode = {
      enable = true;
      package = pkgs.local.vscodium;
      mutableExtensionsDir = true;

      argvSettings = {
        password-store = configData.secretService;
      };
    };
  };
}
