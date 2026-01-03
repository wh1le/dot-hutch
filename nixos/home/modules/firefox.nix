{ ... }: {
  programs.firefox = {
    profiles = {
      default = {
        search = {
          force = true;
          default = "Searx";
          order = [ "Searx" "DuckDuckGo" ];
        };

        engines = {
          "Searx" = {
            urls = [{
              template = "http://127.0.0.1:8882/search";
              params = [
                { name = "q"; value = "{searchTerms}"; }
              ];
            }];
            iconUpdateURL = "https://searx.be/favicon.ico";
            definedAliases = [ "@searx" ];
          };
        };
      };
    };
  };
}
