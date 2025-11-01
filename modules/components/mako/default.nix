{
  flake.modules.nixos.mako = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [ mako ];
  };

  flake.modules.homeManager.mako = { pkgs, config, ... }: {
    home.file.".config/mako/config".text = ''
    icons=1
    icon-path=${pkgs.papirus-icon-theme}/share/icons/Papirus
    font=${config.configData.homeSettings.fonts.latin.ui}, 12
    '';
  };
}
