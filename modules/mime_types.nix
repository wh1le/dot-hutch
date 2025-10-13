{ ... }:

{
  xdg.mime = {
    enable = true;

    defaultApplications = {
      "image/png" = "eog.desktop";
      "image/jpeg" = [ "eog.desktop" ];
      "image/gif" = [ "eog.desktop" ];
      "image/webp" = [ "eog.desktop" ];
      "image/bmp" = [ "eog.desktop" ];
      "image/tiff" = [ "eog.desktop" ];
      "image/svg+xml" = [ "eog.desktop" ];
      "image/x-tga" = [ "eog.desktop" ];

      # Audio
      "audio/mpeg" = [ "vlc.desktop" ];
      "audio/mp3" = [ "vlc.desktop" ];
      "audio/x-wav" = [ "vlc.desktop" ];
      "audio/wav" = [ "vlc.desktop" ];
      "audio/x-flac" = [ "vlc.desktop" ];
      "audio/flac" = [ "vlc.desktop" ];
      "audio/x-vorbis+ogg" = [ "vlc.desktop" ];
      "audio/ogg" = [ "vlc.desktop" ];
      "audio/x-ms-wma" = [ "vlc.desktop" ];
      "audio/aac" = [ "vlc.desktop" ];
      "audio/mp4" = [ "vlc.desktop" ];
      "audio/x-m4a" = [ "vlc.desktop" ];
      "audio/x-opus+ogg" = [ "vlc.desktop" ];
      "audio/opus" = [ "vlc.desktop" ];
      "audio/x-matroska" = [ "vlc.desktop" ];

      # Video
      "video/mp4" = [ "vlc.desktop" ];
      "video/x-matroska" = [ "vlc.desktop" ];
      "video/x-msvideo" = [ "vlc.desktop" ]; # AVI
      "video/x-ms-wmv" = [ "vlc.desktop" ];
      "video/webm" = [ "vlc.desktop" ];
      "video/ogg" = [ "vlc.desktop" ];
      "video/x-flv" = [ "vlc.desktop" ];
      "video/mpeg" = [ "vlc.desktop" ];
      "video/quicktime" = [ "vlc.desktop" ]; # MOV
      "video/3gpp" = [ "vlc.desktop" ];
      "video/3gpp2" = [ "vlc.desktop" ];

      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];

      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";

      "application/pdf" = "firefox.desktop";
    };
  };
}
