{ pkgs, isDesktop, homeConfig, ...  }:

let
  templateFile = import ../../utils/template-engine.nix {pkgs=pkgs;};
in
{
  home.file.".config/foot/foot.ini".source = templateFile "foot-ini-${homeConfig.username}" ./foot.ini.tmpl homeConfig.homeSettings;
}
