{ pkgs, templateFile, isDesktop, configData, ...  }:

let
  settings = { nwgbarPath = pkgs.nwg-bar.outPath; };
in
{
  home.file.".config/nwg-bar/exit-bar/bar.json".source = templateFile "nwg-bar-json-${configData.username}" ./exit-bar/bar.json.tmpl settings;
  home.file.".config/nwg-bar/exit-bar/style.css".source = ./exit-bar/style.css;
}
