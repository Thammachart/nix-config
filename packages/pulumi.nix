{ pkgs, ... }:
let
  pulumi-cli =  pkgs.pulumi-bin.overrideAttrs (finalAttrs: previousAttrs: {
    srcs = [ (builtins.head previousAttrs.srcs) ];
    postUnpack = "";
  });
in
  pulumi-cli
