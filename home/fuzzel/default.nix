{ templateFile, homeConfig, ... }:
{
  home.file.".config/fuzzel/fuzzel.ini".source = templateFile "fuzzel-config-${homeConfig.username}" ./fuzzel.ini.tmpl homeConfig.homeSettings;
}
