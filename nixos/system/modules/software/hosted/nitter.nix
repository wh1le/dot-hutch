{ ... }:
{
  services.nitter = {
    enable = true;

    server = {
      address = "127.0.0.1";
      port = 8200;
    };

    config = {
      enableDebug = false;
      enableRSS = true;
    };

    preferences = {
      replaceTwitter = "";
      replaceYouTube = "";
      replaceReddit = "";
      proxyVideos = true;
      infiniteScroll = false;
      hlsPlayback = false;
    };
  };
}
