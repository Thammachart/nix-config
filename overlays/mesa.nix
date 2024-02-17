{ pkgs-unstable, ... }:
(final: prev: {
  mesa = pkgs-unstable.mesa;
  pkgsi686Linux.mesa = pkgs-unstable.pkgsi686Linux.mesa;
})
