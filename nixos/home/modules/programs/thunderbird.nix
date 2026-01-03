{ ... }:

{
  programs.thunderbird = {
    enable = true;

    #   profiles.default = {
    #     isDefault = true;
    #
    #     settings = {
    #       "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    #     };
    #
    #     # App UI → grayscale
    #     userChrome = ''
    #       :root { filter: grayscale(100%) !important; }
    #     '';
    #
    #     # Message view, composer, prefs, 3-pane → grayscale
    #     userContent = ''
    #       @-moz-document url-prefix(about:message), url-prefix(chrome://messenger/),
    #                      url-prefix(about:3pane), url-prefix(about:preferences),
    #                      url-prefix(about:newtab) {
    #         html, body { filter: grayscale(100%) !important; }
    #       }
    #     '';
    #   };
    # };
  }
