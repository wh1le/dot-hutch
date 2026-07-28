local _video_exts=(
  3g2 3gp amv asf avi divx f4v flv m1v m2t m2ts m2v m4v mkv mov
  mp2 mp4 mp4v mpe mpeg mpg mpg2 mpv mts mxf ogm ogv qt rm rmvb
  ts vob webm wmv y4m
)
local _audio_exts=(
  aac ac3 aif aiff alac ape dts flac m4a mp3 mpc oga ogg opus
  ra shn tak tta wav wma wv
)
local _image_exts=(
  bmp gif ico jpeg jpg png ppm svg tga tif tiff webp
)

alias play_random="mpv --shuffle *"

# TODO: Possibly remove
# media-image-trim-bg() {
#   magick "$1" -crop "$(magick "$1" -channel A -threshold 10% -format '%@' info:)" +repage "$1"
# }
# media-image-resize() {
#   local size="${2:-128}"
#   magick "$1" -resize "${size}x${size}" "$1"
# }

_media-find-by-ext() {
  local pattern=""
  for fmt in "$@"; do
    [[ -n "$pattern" ]] && pattern+=" -o "
    pattern+="-iname '*.$fmt'"
  done
  local files=()
  while IFS= read -r -d '' f; do files+=("$f"); done < <(eval "find . -type f \( $pattern \) -print0")
  print -rN -- "${files[@]}"
}

media-audio-play() {
  local args=("$@")
  local files=()
  while IFS= read -r -d '' f; do files+=("$f"); done < <(_media-find-by-ext "${_audio_exts[@]}")
  if [[ " ${args[*]} " == *" --force-window "* ]]; then
    mpv "${args[@]}" "${files[@]}" &>/dev/null &
    disown
  else
    mpv --no-video "${args[@]}" "${files[@]}"
  fi
}

media-video-play() {
  local args=("$@")
  local files=()
  while IFS= read -r -d '' f; do files+=("$f"); done < <(_media-find-by-ext "${_video_exts[@]}")
  mpv --force-window "${args[@]}" "${files[@]}" &>/dev/null &
  disown
}

media-image-play() {
  local files=()
  while IFS= read -r -d '' f; do files+=("$f"); done < <(_media-find-by-ext "${_image_exts[@]}")
  (( ${#files} == 0 )) && { echo "No images found."; return 1 }
  echo "Opening ${#files} image(s)"
  mpv --force-window --image-display-duration=inf "$@" "${files[@]}" &>/dev/null &
  disown
}

media-images-play() {
  local sock="/tmp/mpv-fb-$$"
  mpv --force-window --idle --input-ipc-server="$sock" "$@" &>/dev/null &
  disown
  sleep 0.5
  echo '{"command":["script-binding","file-browser/browse-files"]}' | socat - "$sock" &>/dev/null
}

_media-video-extract-audio() {
  local remove=$1; shift
  [[ -z "$1" ]] && { echo "Usage: media-video-extract-{cp,mv}-audio <file|dir>"; return 1 }

  local files=()
  if [[ -f "$1" ]]; then
    files=("$1")
  elif [[ -d "$1" ]]; then
    files=("$1"/**/*.(${(j:|:)_video_exts})(N))
  else
    echo "Not a file or directory: $1"; return 1
  fi

  for file in "${files[@]}"; do
    local out="${file:r}.mp3"
    [[ -f "$out" ]] && { echo "Skip (exists): $out"; continue }

    local streams=("${(@f)$(ffprobe -v error -select_streams a -show_entries stream=index,codec_name,channels,sample_rate -of compact "$file")}")
    (( ${#streams} == 0 )) && { echo "No audio streams: $file"; continue }
    local idx=${${streams[1]#*index=}%%|*}
    if (( ${#streams} > 1 )); then
      idx=$({ echo "all"; printf '%s\n' "${streams[@]}" } | fzf --prompt="Select audio stream: ") || continue
      if [[ "$idx" == "all" ]]; then
        for s in "${streams[@]}"; do
          local si=${${s#*index=}%%|*}
          local sout="${file:r}.stream${si}.mp3"
          [[ -f "$sout" ]] && { echo "Skip (exists): $sout"; continue }
          echo "Extracting: $file -> $sout (stream $si)"
          ffmpeg -i "$file" -map 0:$si -vn -acodec libmp3lame -q:a 0 "$sout" || true
        done
        [[ "$remove" == "1" ]] && { echo "Removing: $file"; rm "$file" }
        continue
      fi
      idx=${${idx#*index=}%%|*}
    fi

    echo "Extracting: $file -> $out (stream $idx)"
    ffmpeg -i "$file" -map 0:$idx -vn -acodec libmp3lame -q:a 0 "$out" || continue
    [[ "$remove" == "1" ]] && { echo "Removing: $file"; rm "$file" }
  done
}

media-video-copy-audio() { _media-video-extract-audio 0 "$@" }
media-video-move-audio() { _media-video-extract-audio 1 "$@" }

_media-video-files() { _files -g "*.(${(j:|:)_video_exts})(-.)" -/ }
_media-audio-files() { _files -g "*.(${(j:|:)_audio_exts})(-.)" -/ }

compdef _media-video-files media-video-play media-video-copy-audio media-video-move-audio
compdef _media-audio-files media-audio-play
