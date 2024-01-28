{ pkgs, templateFile, isDesktop, homeConfig, ...  }:

let
  settings = { nwgbarPath = pkgs.nwg-bar.outPath; };
in
{
  home.file.".config/nwg-bar/exit-bar/bar.json".source = templateFile "nwg-bar-json-${homeConfig.username}" ./exit-bar/bar.json.tmpl settings;
  home.file.".config/nwg-bar/exit-bar/style.css".source = ./exit-bar/style.css;
}
