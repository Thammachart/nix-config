
{
  flake.modules.nixos.hosts_asiantuntija-orbit = { pkgs, config, ... }: {
    conditions.isLaptop = true;

    boot.initrd.systemd.enable = true;
    boot.kernelParams = [ "amdgpu.cwsr_enable=0" ];
    # boot.kernelPackages = pkgs.linuxPackages_zen;

    environment.systemPackages = with pkgs; [
      nvtopPackages.amd

      media-downloader
      yt-dlp
      gallery-dl

      # xivlauncher

      qbittorrent-enhanced

      aria2
    ];
  };
}
