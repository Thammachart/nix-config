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
        ui_monospace = "JetBrains Mono";
        terminal_monospace = "Cascadia Mono NF";
      };
      thai = {
        ui = "Noto Sans Thai Looped";
      };
    };
  };

  networking = {
    default = {
      DNS4 = [ "192.168.0.3" ];
      DNS6 = [ "fd00::3" ];
      Gateway4 = "192.168.0.1";
    };
  };

  hosts = {
    "tiikeri-pivot" = {
      tags = [ "personal" "desktop" "hyprland" ];
      networking = {
        ifname = "wlp8s0";
        v4 = { ipaddr = "192.168.10.20/16"; };
        v6 = { ipaddr = "fd00::a:20/96"; };
      };
      u2f = [
        ":R6gc8H4bi/UUmluQkP1dQUVSsbV/ofNM3gH48xEGOvV8jvPLRSLvpCj3FQbqqk0hXlonKE9RqA0Ut9eDwU0RbQrmXC9PsxyakKJi+CdkxFjroBHx5hSiaB5HnmlBSTgYkVadOGi6b/EQm0Mq98CFGSs5kzgGEs1bxhoX8fFGm+g=,oV+LtC06ivUyk6I3vbuq0+W1RBSoUFumVzi6xMgdefU=,eddsa,+presence"
        ":JC1s6sfCjlJm/DeFWlXU9EAzWA52+iI27KmRymTkISjtm5M5sqh0KePUjfX5ed0BxXCT/7sGvdogHkJx5Y+VrEa/+UklxqDTOciujmFtB9+BiQKoeLAMNviumjNgQK8Qh72wVYn+nzQjJW7oWO5xTqZpTfq8y5YAC2hMhvY7QpA=,vj6Ba8uCDosV1lZ+LMR+xCHdF8Q64RCd4CzRpgPvoF8=,eddsa,+presence"

        ":BgoYbl89nhCXbBStZhwRiaIPgPia/FHL++YQpe3hX6RoQdgWjYm5NxCyg/7deD41cQjvuH3KP6DHLGQPwTzQmA==,ka0DZvkCzhaD3nrpLENiK5fU48rSgM2carKjwWxKzNNzNu3esJ1pj9hvFTHZkfCpxoTZxG9E8okE6KrBM5nHUA==,es256,+presence"
        ":pl0PwFp5kEFqfwYyjhdeUlr715jaLbcTxqloCj9Q7eps51GMAC55EVyyk/K0tKysgdgi3cwCiU0NG57/Kmy//A==,oaAdj3bl5p137Q+Vrf+KjFJbbo73YhHDTqMLTjMKcYDiRcEbmbwlNdZGYCwV5py8Bn7TR9upoTGHIn/lkQ3VeA==,es256,+presence"
      ];
      starship = {
        directoryStyle = "fg:#e3e5e5 bg:#2a7505";
      };
    };
    "kenguru-pivot" = {
      tags = [ "personal" "laptop" "server" ];
      networking = {
        ifname = "enp5s0";
        v4 = { ipaddr = "192.168.0.5/16"; };
        v6 = { ipaddr = "fd00::5/96"; };
      };
      u2f = [];
      starship = {
        directoryStyle = "fg:#e3e5e5 bg:#6e2266";
      };
    };
    "hevonen-orbit" = {
      tags = [ "work" "laptop" "netbird" "hyprland" ];
      networking = {
        ifname = "wlp8s0";
        v4 = { ipaddr = "192.168.10.21/16"; };
        v6 = { ipaddr = "fd00::10:21/96"; };
      };
      u2f = [
        ":BRP8MZU1G6k83CyeR5py2hV2Ptma++199+rVUbaXsjaknTAbbZJPV2IqsHUvOGaJ0hmdnND7AdgbGB1a5atKe7sBFEysG5TryX9gf1GlbWxFWs/Jb/CYlP+SVe0NGh7wP/C7C7eBO1F/pji8JRDH/Bg6C84eF8Q1LWPcK1fHz04=,XzciyuaDSb13LaMbMChZOk+MTiIn8mFpVdzVJaKu6yE=,eddsa,+presence"
      ];
      starship = {
        directoryStyle = "fg:#e3e5e5 bg:#2a7505";
      };
    };
  };
}
