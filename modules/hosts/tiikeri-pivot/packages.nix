{
  flake.modules.nixos.hosts_tiikeri-pivot = { pkgs, ... }: {
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

      local.tutanota-desktop
      protonmail-desktop

      # rpcs3
      # heroic
      # cryptomator
    ];
  };
}
