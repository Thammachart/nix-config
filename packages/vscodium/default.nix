{ pkgs, configData, ... }:
(pkgs.vscodium.overrideAttrs (final: prev: {
  pname = prev.pname + "-with-patches";

  postPatch = prev.postPatch + ''
  echo -e '\n.sidebar { font-family: "${configData.homeSettings.fonts.latin.ui_monospace}" !important; }' >> resources/app/out/vs/workbench/workbench.desktop.main.css
  '';
}))
