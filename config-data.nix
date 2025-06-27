{
  username = "thammachart";

  homeSettings = {
    terminal = "footclient";
    browser = "brave";
    editor = "geany";
    launcher = "fuzzel";
    locker = "swaylock -f -c 089966";
    powermenu = "nwg-bar -t ~/.config/nwg-bar/exit-bar/bar.json -s ~/.config/nwg-bar/exit-bar/style.css";

    fonts = {
      latin = {
        ui = "Inter Display";
        ui_monospace = "Adwaita Mono";
        terminal_monospace = "Cascadia Mono NF";
      };
      thai = {
        ui = "Noto Sans Thai Looped";
      };
    };
  };

  hosts = {
    "tiikeri-pivot" = {
      tags = [ "personal" "desktop" "hyprland" ];
    };
    "kenguru-pivot" = {
      tags = [ "personal" "laptop" "server" ];
    };
    "hevonen-orbit" = {
      tags = [ "work" "laptop" "netbird" "hyprland" ];
    };
  };
}
