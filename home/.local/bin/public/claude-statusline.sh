#!/usr/bin/env bash

payload=$(cat)

caveman_out=$(echo "$payload" | bash "$HOME/.claude/plugins/cache/caveman/caveman/600e8efcd6ac/hooks/caveman-statusline.sh")

caveman_out=$(echo "$caveman_out" | sed 's/\[CAVEMAN\]/🧌/g')

# Extract short model label from payload (e.g. "claude-opus-4-6" -> "opus 4.6", "claude-sonnet-4-5" -> "sonnet 4.5")
model_id=$(echo "$payload" | jq -r '.model.id // empty')
model_label=$(echo "$model_id" | sed -E 's/claude-([a-z]+)-([0-9]+)-([0-9]+).*/\2.\3/')

usage_out=$(echo "$payload" | ccusage statusline --visual-burn-rate emoji-text 2>/dev/null | sed -E '
  s/🤖 |💰 |🔥 //g;
  s/Opus[^|]*\| /'"$model_label"' | /g;
  s/Sonnet[^|]*\| /sonnet | /g;
  s/Haiku[^|]*\| /haiku | /g;
  s/ [^|]*\/ (\$?[0-9.]+) block \(([0-9]+h)[^)]*left\)/ \1 (\2)/g;
  s/ \| [^|]*(🟢|🟡|🔴)[^|]*/ \1/g;
  s/\| 🧠 ([0-9,]+) \([^)]+\)/| \1/g;
  s/ ?\| 🧠 N\/A//g;
  s/(🟢|🟡|🔴)\| /\1 | /g
')

if [ -n "$usage_out" ]; then
  echo "$caveman_out $usage_out"
else
  echo "$caveman_out"
fi
