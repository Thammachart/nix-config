
{ config, lib, pkgs, conditions, ... }:
let
  vscodium-fhs-with-patches = import ../packages/vscodium { inherit pkgs; };
in
{
  overlays = [ lib.optionals conditions.graphicalUser {
    vscodium = vscodium-fhs-with-patches;
  } ];
}