{ pkgs, config, lib, ... }:
{
 nixpkgs.overlays = [
  (prev: final: {
    lib = prev.lib // {
      templateFile = import ./template-engine.nix { lib=prev.lib; }
    };
  })
 ];
}
