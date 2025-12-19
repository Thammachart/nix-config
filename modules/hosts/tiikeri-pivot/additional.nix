{ inputs, ... }:
{
  flake.modules.nixos.hosts_tiikeri-pivot = { pkgs, ... }: {
    boot.initrd.systemd.enable = true;
    # boot.kernelPackages = pkgs.linuxPackages_zen;

    environment.systemPackages = with pkgs; [
      local.zen-browser
      nvtopPackages.amd

      protonup-qt

      media-downloader
      yt-dlp
      gallery-dl

      # xivlauncher

      qbittorrent-enhanced

      aria2

      gamescope
      mangohud

      protonmail-desktop
      protonmail-bridge-gui

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
