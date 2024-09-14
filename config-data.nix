{
  username = "thammachart";

  homeSettings = {
    terminal = "footclient";
    browser = "firefox";
    editor = "geany";
    launcher = "fuzzel";
    locker = "swaylock -f -c 089966";
    powermenu = "nwg-bar -t ~/.config/nwg-bar/exit-bar/bar.json -s ~/.config/nwg-bar/exit-bar/style.css";

    fonts = {
      latin = {
        ui = "Inter Display";
        ui_monospace = "JetBrains Mono";
        terminal_monospace = "Cascadia Mono NF";
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
    "kenguru-pivot" = {
      isPersonal = true;
      isDesktop = false;
    };
  };
}
