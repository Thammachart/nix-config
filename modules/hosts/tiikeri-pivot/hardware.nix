let
  xeDevice = "e20b";
in
{
  flake.modules.nixos.hosts_tiikeri-pivot = { pkgs, inputs, config, modulesPath, ... }: {
    imports =
      [
        (modulesPath + "/installer/scan/not-detected.nix")
        inputs.nixos-hardware.nixosModules.common-pc-ssd
      ];

      boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];

      # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
      # (the default) this is the recommended approach. When using systemd-networkd it's
      # still possible to use this option, but it's recommended to use it in conjunction
      # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
      #
      # networking.useDHCP = lib.mkDefault true;
      # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
      # networking.interfaces.wlp8s0.useDHCP = lib.mkDefault true;

      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

      boot.initrd.kernelModules = [];

      ## Experimental Intel Xe Driver
      # boot.kernelParams = [ "i915.force_probe=!${xeDevice}" "xe.force_probe=${xeDevice}" ];

      boot.plymouth = {
        enable = false;
      };

      chaotic.mesa-git = {
        enable = false;

        extraPackages = with pkgs; [
          intel-media-driver
          vpl-gpu-rt
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
          vpl-gpu-rt
        ];

        extraPackages32 = with pkgs.pkgsi686Linux; [
          intel-media-driver
        ];
      };

      powerManagement = {
        enable = true;
        cpuFreqGovernor = "performance";
      };
  };
}
