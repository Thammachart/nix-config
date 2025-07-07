{ pkgs, lib, config, conditions, templateFile, configData, catppuccin-alacritty, ...  }:
lib.mkIf conditions.graphicalUser {
  programs.script-directory = {
    enable = false;
    settings = {
      SD_ROOT = "${config.home.homeDirectory}/.sd";
    };
  };

  home.file.".sd/.alacritty-reset" = {
    text = ''
    #!/bin/sh
    echo -e "\ec" > $_TTY
    '';
    executable = true;
  };

  home.file.".sd/waybar-sway" = {
    text = ''
    #!/bin/sh
    swaymsg 'exec systemd-cat -t waybar waybar -c ~/.config/waybar/sway.json -s ~/.config/waybar/sway.css'
    '';
    executable = true;
  };

  home.file.".local/bin/git-author.sh" = {
    text = ''
      #!/bin/sh
      set -euo pipefail

      PROFILE=~/.config/git/profiles/$1
      USER=$(sed -n '1p' $PROFILE)
      EMAIL=$(sed -n '2p' $PROFILE)

      git config user.name $USER
      git config user.email $EMAIL
    '';
    executable = true;
  };
}
