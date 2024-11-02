{
  username = "thammachart";

  homeSettings = {
    terminal = "alacritty msg create-window";
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
      tags = ["personal" "desktop"];
    };
    "kenguru-pivot" = {
      tags = ["personal" "server" "laptop"];
    };
    "hevonen-orbit" = {
      tags = ["work" "laptop"];
    };
  };
}
