{ pkgs, lib, config, conditions, templateFile, configData, catppuccin-alacritty, ...  }:
lib.mkIf conditions.graphicalUser {
  home.file.".sd/alacritty-reset" = {
    text = ''
    #!/bin/sh
    echo -e "\ec" > $_TTY
    '';
    executable = true;
  };
}
