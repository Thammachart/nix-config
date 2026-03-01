
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
      qbittorrent-enhanced
      aria2

      protonmail-desktop
    ];

    tailscale.autostart = true;
  };
}
