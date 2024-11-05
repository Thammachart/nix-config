{ pkgs, ... }:
pkgs.foot.overrideAttrs (final: pre: {
  pname = "foot-with-patches";

  patches = [
    ## Courtesy to https://codeberg.org/dnkl/foot/pulls/1267
    ./001-output-text-binding.patch
  ];
})
