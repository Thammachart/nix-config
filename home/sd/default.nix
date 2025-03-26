{ pkgs, lib, config, conditions, templateFile, configData, catppuccin-alacritty, ...  }:
lib.mkIf conditions.graphicalUser {
  home.file.".sd/alacritty-reset" = {
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
}
