{
  flake.modules.nixos.hosts_tiikeri-pivot = { pkgs, ... }: {
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

      # rpcs3
      # heroic
      # cryptomator
    ];
  };
}
