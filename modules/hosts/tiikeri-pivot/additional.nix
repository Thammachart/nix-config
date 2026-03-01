{ inputs, ... }:
{
  flake.modules.nixos.hosts_tiikeri-pivot = { pkgs, ... }: {
    boot.initrd.systemd.enable = true;
    # boot.kernelPackages = pkgs.linuxPackages_zen;

    environment.systemPackages = with pkgs; [
      nvtopPackages.amd

      protonup-qt

      # xivlauncher

      qbittorrent-enhanced

      gamescope
      mangohud

      (prismlauncher.override {
        jdks = [ javaPackages.compiler.temurin-bin.jre-21 ];
      })

      # rpcs3
      # heroic
      # cryptomator
    ];

    # services.avahi = {
    #   enable = true;
    #   nssmdns4 = true;
    # };

    # services.printing = {
    #   enable = true;
    #   drivers = with pkgs; [
    #     cups-filters
    #     cups-browsed
    #     epson-escpr2
    #   ];
    # };
  };
}
