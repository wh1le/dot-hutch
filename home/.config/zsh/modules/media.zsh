alias play_random="mpv --shuffle *"

yt-mp3() {
  yt-dlp -x --audio-format mp3 --audio-quality 0 -o "%(title)s.%(ext)s" "$@"
}

yt-video() {
  yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mp4 -o "%(title)s.%(ext)s" "$@"
}

play_videos_with_vlc() {
  local formats=(
    3g2 3gp amv asf avi divx f4v flv m1v m2t m2ts m2v m4v mkv mov
    mp2 mp4 mp4v mpe mpeg mpg mpg2 mpv mts mxf ogm ogv qt rm rmvb
    ts vob webm wmv y4m
  )

  local pattern=""
  for fmt in "${formats[@]}"; do
    [[ -n "$pattern" ]] && pattern+=" -o "
    pattern+="-iname '*.$fmt'"
  done

  eval "find . -type f \( $pattern \) -exec vlc {} +"
}
