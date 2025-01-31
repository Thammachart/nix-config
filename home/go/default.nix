{ config, lib, conditions, templateFile, configData, ... }:
{
	# home.sessionVariables.GOPATH = "${config.home.homeDirectory}/.local/go";
  home.file.".config/go/env".source = templateFile "go-env-${configData.username}" ./env.tmpl { homeDirectory = config.home.homeDirectory; };
}
