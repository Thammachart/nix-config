{pkgs, templateFile, configData, ...}:
{
  home.file.".config/fnott/fnott.ini".source = templateFile "fnott-config-${configData.username}" ./fnott.ini.tmpl configData.homeSettings;
}
