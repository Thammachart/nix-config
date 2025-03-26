{ pkgs, ... }:
pkgs.vscodium.overrideAttrs (final: prev: {
  pname = prev.pname + "-with-patches";

  postPatch = prev.postPatch + ''
  echo -e '\n.sidebar { font-family: "JetBrains Mono" !important; }' >> resources/app/out/vs/workbench/workbench.desktop.main.css
  '';
})
