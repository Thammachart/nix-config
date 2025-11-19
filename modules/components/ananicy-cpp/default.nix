{
  flake.modules.nixos.ananicy-cpp = { pkgs, config, ... }: {
    services.ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = config.services.ananicy.package;
    };
  };
}
