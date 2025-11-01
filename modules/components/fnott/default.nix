{
  flake.modules.homeManager.fnott = { config, ...}: {
    home.file.".config/fnott/fnott.ini".source = config.templateFile "fnott-config" ./fnott.ini.tmpl config.configData.homeSettings;
  };
}
