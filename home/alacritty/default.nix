{ pkgs, lib, conditions, templateFile, configData, ...  }:

lib.mkIf conditions.graphicalUser {
  home.file.".config/alacritty/alacritty.toml".source = templateFile "foot-ini-${configData.username}" ./alacritty.toml configData.homeSettings;
}
