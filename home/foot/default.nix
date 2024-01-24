{ pkgs, templateFile, isDesktop, homeConfig, ...  }:

{
  home.file.".config/foot/foot.ini".source = templateFile "foot-ini-${homeConfig.username}" ./foot.ini.tmpl homeConfig.homeSettings;
}
