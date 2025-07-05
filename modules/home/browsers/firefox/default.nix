{
  lib,
  config,
  pkgs,
  host,
  ...
}:
with lib;
let
  cfg = config.browsers.firefox;
in
{
  options.browsers.firefox = {
    enable = lib.mkEnableOption "Enable Firefox Browser and Configuration";
  };

  config = mkIf cfg.enable {
    xdg.mimeApps.defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
      "text/xml" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
    };

    programs.firefox = {
      enable = true;
      profiles.default = {
        name = "Default";

        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          stylus
          ublock-origin
          tab-stash
          reddit-enhancement-suite
          vimium
          multi-account-containers
          duckduckgo-privacy-essentials
          ghostery
          web-clipper-obsidian
          enhancer-for-youtube
          enhanced-github
          better-darker-docs
          darkreader
        ];

        settings = {
          "browser.uidensity" = 0;
          "gnomeTheme.activeTabContrast" = true;
          "gnomeTheme.hideSingleTab" = false;
          "gnomeTheme.hideWebrtcIndicator" = true;
          "gnomeTheme.systemIcons" = true;
          "gnomeTheme.spinner" = true;
          "identity.fxaccounts.account.device.name" = "${config.infinitas.user.home}@${host}";
          "browser.urlbar.oneOffSearches" = false;
          "browser.search.hiddenOneOffs" = "Google,Yahoo,Bing,Amazon.com,Twitter,Wikipedia (en),YouTube,eBay";
          "extensions.pocket.enabled" = false;
          "browser.urlbar.suggest.engines" = false;
          "browser.urlbar.suggest.openpage" = false;
          "browser.urlbar.suggest.bookmark" = false;
          "browser.urlbar.suggest.addons" = false;
          "browser.urlbar.suggest.pocket" = false;
          "browser.urlbar.suggest.topsites" = false;
        };

        search = {
          force = true;
          default = "DuckDuckGo";
          order = [
            "DuckDuckGo"
            "NixOS Options"
            "Nix Packages"
            "GitHub"
            "HackerNews"
            "Reddit"
          ];

          engines = {
            "DuckDuckGo" = {
              urls = [
                {
                  template = "https://duckduckgo.com/";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            "Nix Packages" = {
              definedAliases = [ "@np" ];
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                    {
                      name = "channel";
                      value = "unstable";
                    }
                  ];
                }
              ];
            };

            "NixOS Options" = {
              definedAliases = [ "@no" ];
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            "SourceGraph" = {
              definedAliases = [ "@sg" ];
              urls = [
                {
                  template = "https://sourcegraph.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            "GitHub" = {
              definedAliases = [ "@gh" ];
              updateInterval = 24 * 60 * 60 * 1000;

              urls = [
                {
                  template = "https://github.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            "Reddit" = {
              definedAliases = [ "@rd" ];
              urls = [
                {
                  template = "https://www.reddit.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
          };
        };
      };
    };
  };
}
