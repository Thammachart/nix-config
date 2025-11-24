{
  flake.modules.nixos.hosts_tiikeri-pivot = { pkgs, ... }: {
    boot.initrd.systemd.enable = true;
    boot.kernelPackages = pkgs.linuxPackages_zen;

    environment.systemPackages = with pkgs; [
      nvtopPackages.intel

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
  };
}
