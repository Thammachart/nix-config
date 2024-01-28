{ pkgs, templateFile, isDesktop, homeConfig, ...  }:

let
  settings = { nwg-bar-path = pkgs.nwg-bar; };
in
{
  home.file.".config/nwg-bar/exit-bar/bar.json.tmpl".source = templateFile "nwg-bar-json-${homeConfig.username}" ./exit-bar/bar.json.tmpl settings;
  home.file.".config/nwg-bar/exit-bar/style.css".source = ./exit-bar/style.css;
}
