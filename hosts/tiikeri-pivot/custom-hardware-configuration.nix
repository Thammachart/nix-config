{ config, lib, pkgs, ... }:
let
  xeDevice = "e20b";
in
{
  boot.initrd.kernelModules = [];

  ## Experimental Intel Xe Driver
  # boot.kernelParams = [ "i915.force_probe=!${xeDevice}" "xe.force_probe=${xeDevice}" ];

  boot.plymouth = {
    enable = false;
  };

  chaotic.mesa-git = {
    enable = false;

    extraPackages = with pkgs; [
      mesa_git.opencl
      intel-media-driver
      intel-ocl
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
    ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      intel-media-driver
      intel-ocl
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
    ];
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };
}
