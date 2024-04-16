{
  username = "thammachart";

  homeSettings = {
    terminal = "footclient";
    browser = "firefox";
    editor = "geany";
    launcher = "fuzzel";
    locker = "swaylock -f -c 000000";
    powermenu = "nwg-bar -t ~/.config/nwg-bar/exit-bar/bar.json -s ~/.config/nwg-bar/exit-bar/style.css";

    fonts = {
      latin = {
        ui = "Inter Display";
        ui_monospace = "JetBrainsMono NFP";
        terminal_monospace = "CaskaydiaCove NFP";
      };
    };
  };

  hosts = {
    "tiikeri-pivot" = {
      isPersonal = true;
      isDesktop = true;
    };
    "hevonen-orbit" = {
      isPersonal = false;
      isDesktop = false;
    };
  };
}
