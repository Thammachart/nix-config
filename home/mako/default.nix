{pkgs, templateFile, configData, ...}:
{
  home.file.".config/mako/config".text = ''
  icons=1
  icon-path=${pkgs.papirus-icon-theme}/share/icons/Papirus
  font=${configData.homeSettings.fonts.latin.ui}, 12
  '';
}
