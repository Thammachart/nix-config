{ pkgs, ... }:
  pkgs.pulumi-bin.overrideAttrs (finalAttrs: previousAttrs: {
    srcs = [ previousAttrs.srcs[0] ]
  })
