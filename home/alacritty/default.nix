{ pkgs, lib, conditions, templateFile, configData, catppuccin-alacritty, ...  }:

lib.mkIf conditions.graphicalUser {
  home.file.".config/alacritty/catppuccin-macchiato.toml".source = "${catppuccin-alacritty}/catppuccin-macchiato.toml";
  home.file.".config/alacritty/alacritty.toml".source = templateFile "foot-ini-${configData.username}" ./alacritty.toml.tmpl configData.homeSettings;
}
