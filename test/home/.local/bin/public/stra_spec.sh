#!/usr/bin/env bash
set -euo pipefail

root=$(cd -- "$(dirname -- "$0")/../../../../.." && pwd)
script="$root/home/.local/bin/public/stra"
sandbox=$(mktemp -d)
trap 'rm -rf -- "$sandbox"' EXIT
export HOME="$sandbox" PATH="$sandbox/bin:$PATH"
install="$HOME/.local/share/strata/ffa80d73133ea5c548aefe57889a16e8085a938f"
mkdir -p "$sandbox/bin" "$install"
printf '#!/usr/bin/env bash\nprintf "<%%s>\\n" "$@"\n' > "$sandbox/bin/strata"
chmod +x "$sandbox/bin/strata"

if bash "$script" run list > /dev/null 2>&1; then exit 1; fi
touch "$install/strata-alpha.json" "$install/strata-beta.json"
[[ $(bash "$script" --help) == '<--help>' ]]
[[ $(bash "$script" run list) == $'alpha\nbeta' ]]
[[ $(bash "$script" run alpha --port 8080) == "$(printf '<%s>\n' serve --profile "$install/strata-alpha.json" --port 8080)" ]]
[[ $(printf '2\n' | bash "$script" run 2>/dev/null) == "$(printf '<%s>\n' serve --profile "$install/strata-beta.json")" ]]
if bash "$script" run unknown > /dev/null 2>&1; then exit 1; else [[ $? == 2 ]]; fi
if bash "$script" calibrate alpha extra > /dev/null 2>&1; then exit 1; else [[ $? == 2 ]]; fi
if bash "$script" calibrate alpha <<< n > /dev/null 2>&1; then exit 1; fi
output=$(bash "$script" calibrate alpha <<< y 2>/dev/null)
[[ "$output" == *'<--measure>'* && "$output" == *'<--review-result>'* && "$output" == *'--apply-result'* ]]
printf 'stra checks passed\n'
