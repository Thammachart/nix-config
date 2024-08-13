{pkgs, templateFile, configData, ...}:
{
  home.file.".config/mako/config".source = templateFile "mako-config-${configData.username}" ./config.tmpl configData.homeSettings;
}
