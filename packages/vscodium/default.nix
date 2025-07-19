{ pkgs, ... }:
(pkgs.vscodium.overrideAttrs (final: prev: {
  pname = prev.pname + "-with-patches";

  postPatch = prev.postPatch + ''
  echo -e '\n.sidebar { font-family: "Iosevka" !important; }' >> resources/app/out/vs/workbench/workbench.desktop.main.css
  '';
})).override { commandLineArgs = [ "--password-store=gnome-libsecret" ]; }
