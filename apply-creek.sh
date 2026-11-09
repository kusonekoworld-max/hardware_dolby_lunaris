#!/usr/bin/env bash
# Usage: hardware/dolby/apply-creek.sh [path device tree creek]
# Default path: ../../device/xiaomi/creek (jalan dari hardware/dolby di tree ROM)
set -e
HW="$(cd "$(dirname "$0")" && pwd)"
DT="$(cd "${1:-$HW/../../device/xiaomi/creek}" && pwd)"
EFF="$DT/configs/audio/audio_effects.xml"
[ -f "$EFF" ] || { echo "audio_effects.xml gak ketemu di $DT"; exit 1; }

# 1. audio_effects (aml.sh): buang dvl/listener/helper, daftarin dap/vqe/gamedap
if grep -q 'dap_mod' "$EFF"; then
  echo "[skip] audio_effects udah ke-patch"
else
  patch -p4 -d "$DT" --dry-run < "$HW/patches/creek-audio_effects.patch" >/dev/null \
    || { echo "[GAGAL] patch gak cocok sama audio_effects.xml di $DT"; exit 1; }
  patch -p4 -d "$DT" < "$HW/patches/creek-audio_effects.patch"
  echo "[ok] audio_effects ke-patch"
fi

# 2. RAW -> NONE di semua audio policy
for f in "$DT"/configs/audio/audio_policy*.xml; do
  [ -f "$f" ] && sed -i 's/AUDIO_OUTPUT_FLAG_RAW/AUDIO_OUTPUT_FLAG_NONE/g' "$f"
done
echo "[ok] AUDIO_OUTPUT_FLAG_RAW -> NONE"

# 3. pastiin dolby.mk ke-inherit
if grep -q 'hardware/dolby/dolby.mk' "$DT/device.mk"; then
  echo "[skip] dolby.mk udah di-inherit"
else
  printf '\n# Dolby\n$(call inherit-product, hardware/dolby/dolby.mk)\n' >> "$DT/device.mk"
  echo "[ok] inherit dolby.mk ditambah ke device.mk"
fi

# 4. cek sisa
grep -n 'dlbvol\|FLAG_RAW' "$DT"/configs/audio/*.xml && echo "[WARN] masih ada sisa di atas" || echo "[ok] bersih"
