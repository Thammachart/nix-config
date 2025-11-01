{
  flake.modules.nixos.mpv = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ mpv ];
  };

  flake.modules.homeManager.mpv = { ... }: {
    home.file.".config/mpv/mpv.conf".source = ./mpv.conf;
    home.file.".config/mpv/input.conf".source = ./input.conf;
  };
}
