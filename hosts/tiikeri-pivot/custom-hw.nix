{ config, lib, pkgs, modulesPath, ... }:

{
  fileSystems."/".options = [ "noatime" "commit=120" "compress=zstd:1" "space_cache=v2" "subvol=@" ];

  fileSystems."/home".options = [ "noatime" "commit=120" "compress=zstd:1" "space_cache=v2" "subvol=@home" ];

  fileSystems."/nix".options = [ "noatime" "commit=120" "compress=zstd:1" "space_cache=v2" "subvol=@nix" ];

  fileSystems."/boot".options = [ "noatime" ];
}
