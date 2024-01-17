{ config, lib, pkgs, ... }:

{
  boot.initrd.kernelModules = [ "amdgpu" ];

  fileSystems."/".options = [ "noatime" "commit=120" "compress=zstd:1" "space_cache=v2" "subvol=@" ];

  fileSystems."/home".options = [ "noatime" "commit=120" "compress=zstd:1" "space_cache=v2" "subvol=@home" ];

  fileSystems."/nix".options = [ "noatime" "commit=120" "compress=zstd:1" "space_cache=v2" "subvol=@nix" ];

  fileSystems."/boot".options = [ "noatime" ];

  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
  ];
  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];
}
