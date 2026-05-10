#!/bin/bash
set -e

WORKSPACE="$1"
ZMK_DIR="$WORKSPACE/zmk"

echo "Updating Zephyr modules..."
cd "$ZMK_DIR"
if [ ! -d ".west" ]; then
  west init -l app/
fi
west update

echo ""
echo "=== Ready to build! ==="
echo ""
echo "Run: ./build.sh"
echo ""
echo "Firmware files will be at:"
echo "  $WORKSPACE/build/left/zephyr/zmk.uf2"
echo "  $WORKSPACE/build/right/zephyr/zmk.uf2"
echo "  $WORKSPACE/build/reset/zephyr/zmk.uf2"
