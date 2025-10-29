{
  flake.modules.homeManager.base = { pkgs, ... }:
    {
      programs.home-manager.enable = true;
    };
}
