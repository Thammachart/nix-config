{
  flake.modules.homeManager.fuzzel = { config, ... }: {
    home.file.".config/fuzzel/fuzzel.ini".source = config.templateFile "fuzzel-config" ./fuzzel.ini.tmpl config.configData.homeSettings;
  };
}
