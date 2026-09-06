export NANOCODER_LOG_LEVEL=error # or 'warn' / 'fatal' (minimal output)
export NANOCODER_LOG_DISABLE_FILE=true
export NANOCODER_LOG_TO_FILE=false
export NANOCODER_CORRELATION_ENABLED=false

export LATITUDE_PI_TELEMETRY_ENABLED=0
export PI_OTEL_DISABLED=1

# safetensors metadata tools — pure stdlib python, no deps
# lm-info <file>   detailed: family, rank, triggers
# lm-family [dir]  recursive: filename -> base family
# lm-type <file>   classify: checkpoint | lora | diffusion | vae | encoder
# lm-type [dir]    recursive: filename -> type

_lm_type() {
  python3 - "$1" <<'PY'
import json, struct, sys

path = sys.argv[1]
try:
    with open(path, "rb") as f:
        n = struct.unpack("<Q", f.read(8))[0]
        hdr = json.loads(f.read(n))
except Exception as e:
    print(f"BROKEN ({e})"); sys.exit(0)

keys = [k for k in hdr if k != "__metadata__"]
ks = "\n".join(keys).lower()
has = lambda *subs: any(s in ks for s in subs)

is_lora = has("lora_", ".lora.", "lora_up", "lora_down", "lora_a", "lora_b")
has_unet = has("diffusion_model", "model.diffusion", "double_blocks", "input_blocks", "joint_blocks")
has_vae  = has("first_stage", "decoder.conv_in", "encoder.down")
has_clip = has("cond_stage", "text_model", "text_encoders", "shared.", "encoder.block")

if is_lora:
    t = "LORA"
elif has_unet and (has_vae or has_clip):
    t = "CHECKPOINT (all-in-one)"
elif has_unet:
    t = "DIFFUSION (needs encoder+vae)"
elif has_vae and not has_clip:
    t = "VAE"
elif has_clip and not has_unet:
    t = "TEXT-ENCODER"
else:
    t = "UNKNOWN"

print(f"{t}  [{len(keys)} tensors]")
PY
}

lm-type() {
  emulate -L zsh
  local f
  if [[ -d "$1" || -z "$1" ]]; then
    local dir="${1:-.}"
    for f in "$dir"/**/*.safetensors(.N); do
      printf '%-52s %s\n' "${f:t}" "$(_lm_type "$f")"
    done
  elif [[ -f "$1" ]]; then
    print "● ${1:t}"
    print "  $(_lm_type "$1")"
  else
    print "usage: lm-type <model.safetensors | dir>"
    return 1
  fi
}

_lm_meta() {
  # $1 = file, $2 = mode (info|family)
  python3 - "$1" "$2" <<'PY'
import json, struct, sys

path, mode = sys.argv[1], sys.argv[2]
try:
    with open(path, "rb") as f:
        n = struct.unpack("<Q", f.read(8))[0]
        meta = json.loads(f.read(n)).get("__metadata__", {})
except Exception as e:
    print(f"!! {e}"); sys.exit(1)

family = meta.get("ss_base_model_version") or meta.get("modelspec.architecture") or "UNKNOWN"

if mode == "family":
    print(family); sys.exit(0)

if not meta:
    print("  (no metadata — stripped)"); sys.exit(0)

fields = {
    "base":   family,
    "module": meta.get("ss_network_module"),
    "dim":    meta.get("ss_network_dim"),
    "alpha":  meta.get("ss_network_alpha"),
    "images": meta.get("ss_num_train_images"),
    "res":    meta.get("ss_resolution"),
}
for k, v in fields.items():
    if v is not None:
        print(f"  {k:8} {v}")

tf = meta.get("ss_tag_frequency")
if tf:
    try:
        flat = {t: c for d in json.loads(tf).values() for t, c in d.items()}
        for t, c in sorted(flat.items(), key=lambda x: -x[1])[:15]:
            print(f"    {c:>6}  {t}")
    except Exception:
        pass
PY
}

lm-info() {
  emulate -L zsh
  [[ -f "$1" ]] || {
    print "usage: lm-info <model.safetensors>"
    return 1
  }
  print "● ${1:t}"
  _lm_meta "$1" info
}

lm-family() {
  emulate -L zsh
  local dir="${1:-.}" f
  for f in "$dir"/**/*.safetensors(.N); do
    printf '%-52s %s\n' "${f:t}" "$(_lm_meta "$f" family)"
  done
}
