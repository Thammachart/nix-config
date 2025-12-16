{
  flake.modules.nixos.mpv = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ zathura ];
  };

  flake.modules.homeManager.zathura = { pkgs, lib, config, ... }: {
    home.file.".config/zathura/zathurarc".source = ./zathurarc;
  };
}
