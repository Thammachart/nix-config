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
        enable-crash-reporter = false;
        crash-reporter-id = "d4e9f7cd-7c83-44cb-bf06-ab3181be23d2";
      };
    };
  };
}
