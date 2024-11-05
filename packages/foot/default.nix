{ pkgs, ... }:
pkgs.foot.overrideAttrs (final: pre: {
  pname = "foot-with-patches";

  patches = [
    ./001-output-text-binding.patch
  ];
})
