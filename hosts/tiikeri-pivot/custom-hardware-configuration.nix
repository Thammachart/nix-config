{ config, lib, pkgs, ... }:

{
  boot.initrd.kernelModules = [ "amdgpu" ];

  fileSystems."/".options = [ "noatime" "commit=120" "compress=zstd:1" "space_cache=v2" "subvol=@" ];

  fileSystems."/home".options = [ "noatime" "commit=120" "compress=zstd:1" "space_cache=v2" "subvol=@home" ];

  fileSystems."/nix".options = [ "noatime" "commit=120" "compress=zstd:1" "space_cache=v2" "subvol=@nix" ];

  fileSystems."/boot".options = [ "noatime" ];

  hardware.opengl = {
    enable = true;

    driSupport = true;
    driSupport32Bit = true;

    extraPackages = with pkgs; [
      amdvlk
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      amdvlk
    ];
  };
}
