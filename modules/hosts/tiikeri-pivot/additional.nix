{ inputs, ... }:
{
  flake.modules.nixos.hosts_tiikeri-pivot = { pkgs, ... }: {
    boot.initrd.systemd.enable = true;
    boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

    environment.systemPackages = with pkgs; [
      nvtopPackages.amd

      qbittorrent-enhanced

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
