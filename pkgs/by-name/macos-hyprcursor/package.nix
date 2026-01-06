{ stdenvNoCC, fetchFromGitHub, lib, ... }:

stdenvNoCC.mkDerivation {
  pname = "mcmojave-hyprcursor";
  version = "7ed49d9";

  src = fetchFromGitHub {
    "owner" = "OtaK";
    "repo" = "McMojave-hyprcursor";
    "rev" = "7ed49d93f7c56df81d085fa8f70c4129956884b2";
    "hash" = "sha256-+Qo88EJC0nYDj9FDsNtoA4nttck81J9CQFgtrP4eBjk=";
  };

  installPhase = ''
    mkdir -p $out/share/icons/McMojave-hyprcursor/
    cp -r dist/* $out/share/icons/McMojave-hyprcursor/
  '';
}
