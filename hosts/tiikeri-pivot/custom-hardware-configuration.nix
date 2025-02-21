{ config, lib, pkgs, ... }:

{
  boot.initrd.kernelModules = [];

  boot.plymouth = {
    enable = false;
  };

  chaotic.mesa-git = {
    enable = true;

    extraPackages = with pkgs; [
      mesa_git.opencl intel-media-driver intel-ocl
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
    ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      intel-media-driver intel-ocl
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
