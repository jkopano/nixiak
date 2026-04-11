{ den, ... }:
{
  den.aspects.gui._.browser.homeManager =
    { config, pkgs, inputs, lib, ... }:
    let
      default = "default";
      inherit (config.var) pwa;
    in
    {
      home.file.".mozilla/firefox/${default}/userChrom.css" = {
        source = ./userChrome.css;
      };

      programs.firefoxpwa = {
        enable = true;
        profiles = {
          "01K07PG97Y67G6CHB6TZJ69MHX" = {
            name = "Pwa";
            sites = {
              ${pwa.twitter} = {
                name = "Twitter";
                url = "https://x.com/?utm_source=homescreen&utm_me";
                manifestUrl = "https://x.com/manifest.json";
                desktopEntry = {
                  icon = pkgs.fetchurl {
                    url = "https://abs.twimg.com/favicons/twitter-pip.3.ico";
                    sha256 = "06fx81kq5f572fvan23srfq26466d9snawh3v21j3dp57f8y7bzw";
                  };
                };
              };
              ${pwa.messenger} = {
                name = "Messenger";
                url = "https://www.messenger.com/";
                manifestUrl = "https://www.messenger.com/manifest.json";
                desktopEntry = {
                  icon = pkgs.fetchurl {
                    url = "https://static.xx.fbcdn.net/rsrc.php/yO/r/qa11ER6rke_.ico";
                    sha256 = "0hgcw00xbj3x67isdnszbhjyzy7nfksy1mz9ji0q5njnc83bm79y";
                  };
                };
              };
              ${pwa.reddit} = {
                name = "Reddit";
                url = "https://www.reddit.com/";
                manifestUrl = "https://www.reddit.com/manifest.json";
              };
            };
          };
        };
      };
      programs.firefox = {
        enable = true;
        nativeMessagingHosts = [
          pkgs.firefoxpwa
        ];

        package = pkgs.wrapFirefox pkgs.firefox-bin-unwrapped {
          extraPolicies = {
            CaptivePortal = false;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            DisableTelemetry = true;
            DisableFirefoxAccounts = false;
            NoDefaultBookmarks = true;
            OfferToSaveLogins = false;
            OfferToSaveLoginsDefault = false;
            PasswordManagerEnabled = false;
            FirefoxHome = {
              Search = true;
              Pocket = false;
              Snippets = false;
              TopSites = false;
              Highlights = false;
            };
            UserMessaging = {
              ExtensionRecommendations = false;
              SkipOnboarding = true;
            };
          };
        };

        profiles = {
          ${default} = {
            id = 0;
            name = "cqws";
            isDefault = true;

            extensions.packages = with pkgs.firefoxAddons; [
              ublock-origin
              vimium-ff
              duckduckgo-for-firefox
              sponsorblock
              i-dont-care-about-cookies
              keepassxc-browser
              ultimadark
              pwas-for-firefox
              clearurls
              return-youtube-dislikes
            ];

            settings = {
              "sidebar.revamp" = true;
              "sidebar.verticalTabs" = true;
              "browser.search.defaultenginename" = "duckduckgo";
              "permissions.default.shortcuts" = 0;
              "ui.key.menuAccessKey" = 0;
              "browser.zoom.default" = 1.1;
              "browser.shell.checkDefaultBrowser" = false;
              "browser.shell.defaultBrowserCheckCount" = 1;
              "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
              "browser.newtabpage.activity-stream.improvesearch.handoffToAwesomebar" = false;
              "widget.use-xdg-desktop-portal.file-picker" = 1;
              "widget.use-xdg-desktop-portal.mime-handler" = 1;
              "widget.gkt.rounded-bottom-corners.enabled" = true;
              "widget.gkt.ignore-bogus-leave-notify" = 1;
              "browser.search.suggest.enabled" = false;
              "browser.search.suggest.enabled.private" = false;
              "browser.urlbar.suggest.searches" = false;
              "browser.urlbar.showSearchSuggestionsFirst" = false;
              "browser.sessionstore.enabled" = true;
              "browser.sessionstore.resume_from_crash" = true;
              "browser.sessionstore.resume_session_once" = true;
              "browser.tabs.insertAfterCurrent" = true;
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
              "browser.tabs.drawInTitlebar" = true;
              "svg.context-properties.content.enabled" = true;
              "general.smoothScroll" = true;
              "uc.tweak.hide-tabs-bar" = true;
              "uc.tweak.hide-forward-button" = true;
              "uc.tweak.rounded-corners" = true;
              "uc.tweak.floating-tabs" = true;
              "layout.css.light-dark.enabled" = true;
              "layout.css.has-selector.enabled" = true;
              "layout.css.devPixelsPerPx" = "1.1";
              "media.ffmpeg.vaapi.enabled" = true;
              "media.rdd-vpx.enabled" = true;
              "browser.tabs.tabmanager.enabled" = false;
              "full-screen-api.ignore-widgets" = false;
              "browser.urlbar.suggest.engines" = false;
              "browser.urlbar.suggest.openpage" = false;
              "browser.urlbar.suggest.bookmark" = false;
              "browser.urlbar.suggest.addons" = false;
              "browser.urlbar.suggest.pocket" = false;
              "browser.urlbar.suggest.topsites" = false;
              "browser.urlbar.suggest.calculator" = true;
              "browser.urlbar.suggest.uniConversion.enabled" = true;
              "browser.urlbar.trimHttps" = true;
              "browser.urlbar.trimURLs" = true;
            };
          };
        };
      };
    };
}
