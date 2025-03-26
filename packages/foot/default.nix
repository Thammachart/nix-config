{ pkgs, ... }:
pkgs.foot.overrideAttrs (final: prev: {
  pname = prev.pname + "with-patches";

  patches = [
    ## Courtesy to https://codeberg.org/dnkl/foot/pulls/1267
    ./001-output-text-binding.patch
  ];
})
