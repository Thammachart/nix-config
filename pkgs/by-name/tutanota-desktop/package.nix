{ pkgs, ... }:
let
  chromiumPasswordStore = "--password-store=kwallet6";
in
pkgs.tutanota-desktop.override {
  commandLineArgs = [
    "--ozone-platform=wayland"
    chromiumPasswordStore
  ];
}
