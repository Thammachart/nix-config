{ pkgs, lib, configData, conditions, betterfox, gitalias, ... }:

{
  imports = [
    # ./hypr
    ./mako
    ./kanshi
    ./sway
    ./river
    ./foot
    ./mpv
    ./waybar
    ./nwg-bar
    ./fuzzel
    ./nushell
  ];

  home = {
    username = "${configData.username}";
    homeDirectory = "/home/${configData.username}";

    pointerCursor = lib.mkIf conditions.graphicalUser {
      name = "Yaru";
      package = pkgs.yaru-theme;
      size = 24;
      gtk.enable = true;
    };

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "24.05";
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  gtk = {
    enable = conditions.graphicalUser;
    font = {
      name = configData.homeSettings.fonts.latin.ui;
      size = 12;
    };
    iconTheme = {
      name = "Papirus-Dark";
    };
    theme = {
      name = "Yaru-dark";
      package = pkgs.yaru-theme;
    };
  };

  xdg.configFile = lib.mkIf conditions.graphicalUser {
    "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=KvArcDark";
  };

  programs.firefox = {
    enable = conditions.graphicalUser;
    profiles.default = {
      id = 0;
      isDefault = true;

      extraConfig = builtins.concatStringsSep "\n" [
        (builtins.readFile "${betterfox}/Fastfox.js")
      ];

      settings = {
        "browser.ctrlTab.sortByRecentlyUsed" = false;
        "browser.translations.neverTranslateLanguages" = "th";
        "privacy.clearOnShutdown.history" = false;
        "devtools.chrome.enabled" = true;
        "browser.tabs.crashReporting.sendReport" = false;

        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "widget.dmabuf.force-enabled" = true;
        "media.av1.enabled" = false;

        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.userContext.enabled" = true;
        "privacy.userContext.ui.enabled" = true;

        "app.normandy.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;

        "browser.send_pings" = false;

        "beacon.enabled" = false;
        "device.sensors.enabled" = false;
        "geo.enabled" = false;

        "network.dns.echconfig.enabled" = true;

        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.unified" = false;

        "extensions.webcompat-reporter.enabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.urlbar.eventTelemetry.enabled" = false;

        "extensions.pocket.enabled" = false;
        "extensions.abuseReport.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "identity.fxaccounts.enabled" = false;
        "identity.fxaccounts.toolbar.enabled" = false;
        "identity.fxaccounts.pairing.enabled" = false;
        "identity.fxaccounts.commands.enabled" = false;
        "browser.contentblocking.report.lockwise.enabled" = false;
        "browser.uitour.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      };

    };
  };

  programs.git = {
    enable = true;
    userName = "Thammachart";
    userEmail = "1731496+Thammachart@users.noreply.github.com";
    extraConfig = {
      merge = {
        log = 100;
      };
    };

    includes = [
      { path = "${gitalias}/gitalias.txt"; }
    ];
  };

  programs.aria2 = {
    enable = (conditions.isPersonal && !conditions.isServer);
    settings = {
      allow-overwrite = true;
      # log = "-";
      console-log-level = "notice";
      # file-allocation = "falloc";

      # summary-interval = 120;

      enable-rpc = true;
      rpc-secure = false;
      rpc-listen-all = false;
      rpc-listen-port = 6802;
      rpc-allow-origin-all = true;

      max-concurrent-downloads = 2;
      max-connection-per-server = 1;

      dir = "/data/sda1/Times/High";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
