{ pkgs, lib, conditions, templateFile, configData, catppuccin-alacritty, ...  }:
lib.mkIf conditions.graphicalUser {
  programs.script-directory = {
    enable = true;
    settings = {
      SD_ROOT = "${config.home.homeDirectory}/.sd";
      SD_EDITOR = "hx";
      SD_CAT = "bat";
    };
  };

  home.file.".sd/alacritty-reset" = {
    text = "";
    executable = true;
  };
}
