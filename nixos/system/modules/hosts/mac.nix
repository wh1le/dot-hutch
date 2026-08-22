{ config, pkgs, ... }:
let
  caBundle = "/etc/ssl/certs/nix-corp-bundle.pem";
  corpCa = "${config.users.users.${config.my.username}.home}/.secrets/corp-ca.pem";
  screenshotDir = "${config.users.users.${config.my.username}.home}/Pictures/screenshots";
in
{
  imports = [
    ../software/sketchybar.nix
    ../homebrew.nix
  ];

  system.primaryUser = config.my.username;

  networking.computerName = "mac";
  networking.localHostName = "mac";

  users.users.${config.my.username}.home = "/Users/${config.my.username}";

  nix.enable = false;

  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;

  environment.variables = {
    # Trust the inspecting proxy in every Nix-provided tool.

    # NIX_SSL_CERT_FILE = caBundle;
    # SSL_CERT_FILE = caBundle;
    # GIT_SSL_CAINFO = caBundle;
    # CURL_CA_BUNDLE = caBundle;
  };

  # nixpkgs CA set plus a local CA from ~/.secrets/corp-ca.pem, falling back
  # to the System keychain, so Nix-provided tools trust an inspecting proxy.
  system.activationScripts.extraActivation.text = ''
    			umask 022
    			caTmp="$(mktemp)"
    			cat ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt > "$caTmp"
    			if [ -f ${corpCa} ]; then
    				cat ${corpCa} >> "$caTmp"
    			else
    				/usr/bin/security find-certificate -a -p /Library/Keychains/System.keychain >> "$caTmp" 2>/dev/null || true
    			fi
    			/usr/bin/install -m 0644 "$caTmp" ${caBundle}
    			rm -f "$caTmp"

    			/usr/bin/install -d -m 0755 \
    				-o ${config.my.username} -g staff ${screenshotDir}
    	'';

  system.startup.chime = false;

  system.defaults = {
    # ".GlobalPreferences".com.apple.sound.beep.sound = "Funk";
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
      # I like an empty dock, I don't use it.
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
      # Hot corners, disable all of them.
      wvous-tl-corner = 1;
      # wvous-tl-modifier = 0;
      wvous-tr-corner = 1;
      # wvous-tr-modifier = 0;
      wvous-bl-corner = 1;
      # wvous-bl-modifier = 0;
      wvous-br-corner = 1;
      # wvous-br-modifier = 0;
    };

    menuExtraClock = {
      Show24Hour = true;
      ShowDate = 1; # always
      ShowDayOfWeek = true;
    };

    finder = {
      AppleShowAllExtensions = true;
      # QuitMenuItem = true;
      _FXShowPosixPathInTitle = false; # In Big Sur this is so UGLY!
      FXPreferredViewStyle = "Nlsv"; # List view
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

    # Extra config not directly supported by nix-darwin
    CustomUserPreferences = {
      NSGlobalDomain = {
        # Add a context menu item for showing the Web Inspector in web views
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
        # Space-switch slide and Mission Control animations.
        workspaces-swoosh-animation-off = true;
        expose-animation-duration = 0.0;
        springboard-show-duration = 0.0;
        springboard-hide-duration = 0.0;
        springboard-page-duration = 0.0;
      };
      "org.hammerspoon.Hammerspoon" = {
        MJConfigFile = "~/.config/hammerspoon/init.lua";
      };
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
        # Avoid creating .DS_Store files on network or USB volumes
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.screensaver" = {
        # Require password immediately after sleep or screen saver begins
        askForPassword = 1;
        askForPasswordDelay = 0;
      };
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
      };
      "com.apple.print.PrintingPrefs" = {
        # Automatically quit printer app once the print jobs complete
        "Quit When Finished" = true;
      };
      "com.apple.SoftwareUpdate" = {
        AutomaticCheckEnabled = true;

        # Download newly available updates in background
        AutomaticDownload = 1;

        # Install System data files & security updates
        CriticalUpdateInstall = 1;
      };
      "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
      # Prevent Photos from opening automatically when devices are plugged in
      "com.apple.ImageCapture".disableHotPlug = true;
      # Turn on app auto-update
      "com.apple.commerce".AutoUpdate = true;
    };
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  environment.systemPackages = [
    pkgs.sbarlua
  ];
}
