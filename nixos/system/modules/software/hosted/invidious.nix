{ ... }:
{
  services.invidious = {
    enable = true;

    address = "127.0.0.1";
    port = 8100;

    settings = {
      statistics_enabled = false;
      use_pubsub_feeds = false;
      registration_enabled = false;
      login_enabled = false;
      enable_user_notifications = false;

      default_user_preferences.automatic_instance_redirect = false;
    };
  };
}
