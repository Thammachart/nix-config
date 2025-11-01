{
  flake.modules.homeManager.go-config = { config, ...}: {
    home.sessionVariables.GOPATH = "${config.home.homeDirectory}/.local/go";
  };
}
