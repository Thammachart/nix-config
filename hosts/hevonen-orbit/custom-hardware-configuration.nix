{ config, lib, pkgs, pkgs-stable, nixos-hardware, modulesPath, ... }:

{
  # imports = [
  #   nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2
  # ];

  boot.initrd.kernelModules = [ "amdgpu" ];

  # fileSystems."/".options = [ "noatime" "commit=120" "compress=zstd:1" "space_cache=v2" "subvol=@" ];

  # fileSystems."/home".options = [ "noatime" "commit=120" "compress=zstd:1" "space_cache=v2" "subvol=@home" ];

  # fileSystems."/nix".options = [ "noatime" "commit=120" "compress=zstd:1" "space_cache=v2" "subvol=@nix" ];

  # fileSystems."/boot".options = [ "noatime" ];

  hardware.graphics = {
    enable = true;
  };
}
