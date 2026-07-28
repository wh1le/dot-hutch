#!/usr/bin/env bash
# copyq-backed clipboard source for the launcher fzf panel.
# Emits "ROW<TAB>content" lines (cliphist-compatible shape) so the
# Clipboard.qml preview can reuse its image/text detection.
set -euo pipefail

case "${1:-list}" in
  list)
    copyq eval -- '
      for (var i = 0; i < size(); ++i) {
        var png = read("image/png", i);
        if (png.size && png.size() > 0) {
          print(i + "\t[[ binary data " + Math.round(png.size() / 1024) + " KiB png ]]\n");
          continue;
        }
        var t = str(read(i)).replace(/\s+/g, " ").trim();
        if (t.length === 0) continue;
        if (t.length > 200) t = t.substr(0, 200);
        print(i + "\t" + t + "\n");
      }'
    ;;
  preview)
    id="${2%%$'\t'*}"
    [[ -z "$id" ]] && exit 0
    content="${2#*$'\t'}"
    if [[ "$content" == '[[ binary data'* ]]; then
      # Image row has no text format, so copyq read is empty and the preview pane
      # stays blank. Emit the marker so the pane activates; Clipboard.qml then
      # decodes the actual image via `copyq read image/png`.
      printf '%s' "$content"
    else
      copyq read "$id"
    fi
    ;;
  select)
    id="${2%%$'\t'*}"
    [[ -z "$id" ]] && exit 0
    copyq read "$id" | copyq copy -
    paplay "$SOUND_THEME_PATH/completion-partial.oga" &
    ;;
esac
