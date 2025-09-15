{ pkgs, lib, configData, conditions, betterfox, ... }:
{
  programs.floorp = {
    enable = false;

    package = null;

    # settings = {
    #   "webgl.disabled" = false;
    #   "privacy.resistFingerprinting" = false;
    #   "privacy.clearOnShutdown.history" = false;
    #   "privacy.clearOnShutdown.cookies" = false;
    #   "network.cookie.lifetimePolicy" = 0;
    # };

    profiles.default = {
      id = 0;
      isDefault = true;

      extraConfig = builtins.concatStringsSep "\n" [
        (builtins.readFile "${betterfox}/Fastfox.js")
      ];

      settings = {
        "floorp.panelSidebar.enabled" = false;
        "browser.ctrlTab.sortByRecentlyUsed" = false;
        "browser.translations.neverTranslateLanguages" = "th";
        "privacy.clearOnShutdown.history" = false;
        "devtools.chrome.enabled" = true;
        "browser.tabs.crashReporting.sendReport" = false;
        "general.smoothScroll" = false;

        # "gfx.webrender.all" = true;
        # "media.ffmpeg.vaapi.enabled" = true;
        # "widget.dmabuf.force-enabled" = true;
        # "media.av1.enabled" = false;
        # "media.hardware-video-decoding.force-enabled" = conditions.isLaptop;

        "signon.rememberSignons" = false;
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

        "browser.tabs.inTitlebar" = 0;
        "browser.tabs.hoverPreview.showThumbnails" = false;
      };
    };
  };
}
