{
  system = "x86_64-linux";

  flake.modules.nixos."hosts/kenguru-pivot" = { pkgs, modulesPath, ... }: {
    imports =
      [
        (modulesPath + "/installer/scan/not-detected.nix")
        inputs.nixos-hardware.nixosModules.common-pc-ssd
      ];

    boot.initrd.availableKernelModules = [ "nvme" "ehci_pci" "xhci_pci" "uas" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    boot.initrd.kernelModules = [ "amdgpu" ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    # nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    hardware.graphics.enable = false;
  };
}
