{ config, ... }:
let
  screenshotDir = "${config.users.users.${config.my.username}.home}/Pictures/screenshots";
in
{
  system.defaults = {
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
    loginwindow.GuestEnabled = false;

    NSGlobalDomain = {
      AppleFontSmoothing = 2;
      AppleKeyboardUIMode = 3;
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = 1;
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Automatic";
      AppleTemperatureUnit = "Celsius";
      InitialKeyRepeat = 25;
      KeyRepeat = 0;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      NSTableViewDefaultSizeMode = 2;
      NSTextShowsControlCharacters = true;
      NSAutomaticWindowAnimationsEnabled = false;
      NSScrollAnimationEnabled = false;
      NSWindowResizeTime = 0.001;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
      _HIHideMenuBar = true;
      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.sound.beep.feedback" = 0;
      "com.apple.springing.delay" = 0.0;
      "com.apple.springing.enabled" = true;
    };

    dock = {
      persistent-apps = [ ];
      orientation = "bottom";
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.0;
      dashboard-in-overlay = true;
      expose-animation-duration = 0.0;
      expose-group-apps = false;
      launchanim = false;
      mineffect = "scale";
      minimize-to-application = true;
      mouse-over-hilite-stack = true;
      show-process-indicators = false;
      show-recents = false;
      showhidden = true;
      static-only = true;
      tilesize = 32;
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
    };

    menuExtraClock = {
      Show24Hour = true;
      ShowDate = 1;
      ShowDayOfWeek = true;
    };

    finder = {
      AppleShowAllExtensions = true;
      _FXShowPosixPathInTitle = false;
      FXPreferredViewStyle = "Nlsv";
      ShowStatusBar = true;
    };

    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };

    screencapture = {
      disable-shadow = true;
      show-thumbnail = false;
      target = "file";
      location = screenshotDir;
    };

    CustomUserPreferences = {
      NSGlobalDomain = {
        WebKitDeveloperExtras = true;
        AppleInterfaceStyle = "Dark";
        NSWindowCornerRadius = 0;
        NSAutomaticWindowAnimationsEnabled = false;
        NSWindowSupportsAutomaticInlineTitle = false;
        NSToolbarFullScreenAnimationDuration = 0.0;
        NSBrowserColumnAnimationSpeedMultiplier = 0.0;
        NSScrollViewRubberbanding = false;
        NSScrollAnimationEnabled = false;
        QLPanelAnimationDuration = 0.0;
      };
      "com.apple.dock" = {
        workspaces-swoosh-animation-off = true;
        expose-animation-duration = 0.0;
        springboard-show-duration = 0.0;
        springboard-hide-duration = 0.0;
        springboard-page-duration = 0.0;
      };
      "org.hammerspoon.Hammerspoon".MJConfigFile = "~/.config/hammerspoon/init.lua";
      "com.apple.finder" = {
        DisableAllAnimations = true;
        WarnOnEmptyTrash = false;
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = true;
        ShowMountedServersOnDesktop = true;
        ShowRemovableMediaOnDesktop = true;
        _FXSortFoldersFirst = true;
      };
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.screensaver" = {
        askForPassword = 1;
        askForPasswordDelay = 0;
      };
      "com.apple.AdLib".allowApplePersonalizedAdvertising = false;
      "com.apple.print.PrintingPrefs"."Quit When Finished" = true;
      "com.apple.SoftwareUpdate" = {
        AutomaticCheckEnabled = true;
        AutomaticDownload = 1;
        CriticalUpdateInstall = 1;
      };
      "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
      "com.apple.ImageCapture".disableHotPlug = true;
      "com.apple.commerce".AutoUpdate = true;
    };
  };
}
