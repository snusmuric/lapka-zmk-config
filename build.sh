#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZMK_DIR="$SCRIPT_DIR/zmk"

cd "$ZMK_DIR"

echo "Building left half..."
west build -s app -d "$SCRIPT_DIR/build/left"  -b nice_nano -- -DSHIELD=lapka_left  -DZMK_CONFIG="$SCRIPT_DIR"
echo "  -> $SCRIPT_DIR/build/left/zephyr/zmk.uf2"

echo ""
echo "Building right half..."
west build -s app -d "$SCRIPT_DIR/build/right" -b nice_nano -- -DSHIELD=lapka_right -DZMK_CONFIG="$SCRIPT_DIR"
echo "  -> $SCRIPT_DIR/build/right/zephyr/zmk.uf2"

echo ""
echo "Building settings reset..."
west build -s app -d "$SCRIPT_DIR/build/reset" -b nice_nano -- -DSHIELD=settings_reset -DZMK_CONFIG="$SCRIPT_DIR"
echo "  -> $SCRIPT_DIR/build/reset/zephyr/zmk.uf2"

echo ""
echo "=== Done ==="
echo ""
echo "Firmware files:"
echo "  $SCRIPT_DIR/build/left/zephyr/zmk.uf2"
echo "  $SCRIPT_DIR/build/right/zephyr/zmk.uf2"
echo "  $SCRIPT_DIR/build/reset/zephyr/zmk.uf2"
