{ pkgs, templateFile, isDesktop, ...  }:

let
  config = import ../config.nix;
in
{
  home.file.".config/foot/foot.ini".source = templateFile "foot-ini-${config.username}" ./foot.ini.tmpl config.homeSettings;
}
