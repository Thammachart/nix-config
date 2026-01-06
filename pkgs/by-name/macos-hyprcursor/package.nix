{ stdenvNoCC, fetchFromGitHub, lib, ... }:

stdenvNoCC.mkDerivation {
  pname = "macos-hyprcursor";
  version = "7ed49d9";

  src = fetchFromGitHub {
    "owner"= "driedpampas";
    "repo"= "macOS-hyprcursor";
    "rev"= "c5c2bd698b681c6548fc35b0504df13ef5565145";
    "hash"= "sha256-W7Uglem1qcneRFg/eR6D20p+ggkSFwh5QJYfq8OisLk=";
  };

  installPhase = ''
    mkdir -p $out/share/icons/
    cp -r themes/SVG/* $out/share/icons/
    cp -r themes/PNG/* $out/share/icons/
  '';
}
