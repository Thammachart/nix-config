{ pkgs, ... }:
pkgs.netbird.overrideAttrs (final: prev:
let
  version = "0.66.3";
  hash = "sha256-Cj9AcdWdHAfdBbqKAkwk3/Vy24XicjTZpmRXLYkyx3k=";
in
{
  inherit version;

  src = fetchFromGitHub {
    owner = "netbirdio";
    repo = "netbird";
    tag = "v${version}";
    inherit hash;
  };
})
