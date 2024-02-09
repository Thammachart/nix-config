{ templateFile, homeConfig, ... }:
{
  home.file.".config/sway/variables".source = templateFile "fuzzel-config-${homeConfig.username}" ./fuzzel.ini.tmpl homeConfig.homeSettings;
}
