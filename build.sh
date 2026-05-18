#!/bin/bash
set -e
cd /workspaces/lapka-zmk-config/zmk/app || exit

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "Script directory: $SCRIPT_DIR"

rm -rf "$SCRIPT_DIR/build" "$SCRIPT_DIR/out"

west build -d "$SCRIPT_DIR/build/left" -b nice_nano -- -DZMK_CONFIG="/workspaces/zmk-config/config" -DZMK_EXTRA_MODULES="/workspaces/zmk-config/zmk-userspace;/workspaces/zmk-config/zmk-helpers" -DSHIELD="lapka_left"  
west build -d "$SCRIPT_DIR/build/right" -b nice_nano -- -DZMK_CONFIG="/workspaces/zmk-config/config" -DZMK_EXTRA_MODULES="/workspaces/zmk-config/zmk-userspace;/workspaces/zmk-config/zmk-helpers" -DSHIELD="lapka_right"

mkdir -p /workspaces/zmk-config/out/
cp "$SCRIPT_DIR/build/left/zephyr/zmk.uf2" /workspaces/zmk-config/out/lapka_left.uf2
cp "$SCRIPT_DIR/build/right/zephyr/zmk.uf2" /workspaces/zmk-config/out/lapka_right.uf2

# SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# ZMK_DIR="$SCRIPT_DIR/zmk"
# ZMK_HELPER_DIR="$SCRIPT_DIR/zmk-helpers"
# ZMK_USERSPACE_DIR="$SCRIPT_DIR/zmk-userspace"

# echo "Script directory: $SCRIPT_DIR"
# echo "ZMK helper directory: $ZMK_HELPER_DIR"
# echo "ZMK userspace directory: $ZMK_USERSPACE_DIR"

# ZMK_EXTRA_MODULES="$ZMK_HELPER_DIR;$ZMK_USERSPACE_DIR"
# echo "ZMK extra modules: $ZMK_EXTRA_MODULES"

# cd "$ZMK_DIR"

# rm -rf "$SCRIPT_DIR/build" "$SCRIPT_DIR/out"
# echo "Building left half..."
# west build -s app -d "$SCRIPT_DIR/build/left" -b nice_nano -- -DZMK_CONFIG="/workspaces/zmk-config/config" -DSHIELD="lapka_left" -DZMK_CONFIG="$SCRIPT_DIR/config" -DZMK_EXTRA_MODULES="$ZMK_EXTRA_MODULES"
# echo "  -> $SCRIPT_DIR/build/left/zephyr/zmk.uf2"

# echo ""
# echo "Building right half..."
# west build -s app -d "$SCRIPT_DIR/build/right" -b nice_nano -- -DZMK_CONFIG="/workspaces/zmk-config/config" -DSHIELD="lapka_right" -DZMK_CONFIG="$SCRIPT_DIR/config" -DZMK_EXTRA_MODULES="$ZMK_EXTRA_MODULES"
# echo "  -> $SCRIPT_DIR/build/right/zephyr/zmk.uf2"

# echo ""
# echo "Building settings reset..."
# west build -s app -d "$SCRIPT_DIR/build/reset" -b nice_nano -- -DZMK_CONFIG="/workspaces/zmk-config/config" -DSHIELD="settings_reset" -DZMK_CONFIG="$SCRIPT_DIR/config" -DZMK_EXTRA_MODULES="$ZMK_EXTRA_MODULES"
# echo "  -> $SCRIPT_DIR/build/reset/zephyr/zmk.uf2"

# echo ""
# echo "=== Done ==="
# echo ""

# mkdir -p "$SCRIPT_DIR/out"
# cp "$SCRIPT_DIR/build/left/zephyr/zmk.uf2" "$SCRIPT_DIR/out/lapka_left.uf2"
# cp "$SCRIPT_DIR/build/right/zephyr/zmk.uf2" "$SCRIPT_DIR/out/lapka_right.uf2"
# cp "$SCRIPT_DIR/build/reset/zephyr/zmk.uf2" "$SCRIPT_DIR/out/settings_reset.uf2"

# echo "Firmware files:"
# echo "  $SCRIPT_DIR/out/lapka_left.uf2"
# echo "  $SCRIPT_DIR/out/lapka_right.uf2"
# echo "  $SCRIPT_DIR/out/settings_reset.uf2"
