#!/usr/bin/env bash
set -e

ROOT="$(pwd)"
SRC="$ROOT/pcsc-lite"
BUILD="$ROOT/build"
PREFIX="$ROOT/output"

export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig"
export CFLAGS="-O2 -pipe"
export LDFLAGS=""

echo "== Configure =="
rm -rf "$BUILD"
mkdir -p "$BUILD"

meson setup "$BUILD" "$SRC" \
  --cross-file "$ROOT/meson_cross_file.txt" \
  --prefix="$PREFIX" \
  --libdir=lib \
  -Dembedded=true \
  -Dusb=true \
  -Dlibusb=true \
  -Dlibudev=true \
  -Dlibsystemd=false \
  -Dpolkit=false \
  -Dserial=false \
  -Dman=false \
  -Ddoc=false

echo "== Build =="
ninja -C "$BUILD"

echo "== Install =="
ninja -C "$BUILD" install

echo "== Strip =="
arm-linux-gnueabihf-strip "$PREFIX/sbin/pcscd" || true
arm-linux-gnueabihf-strip "$PREFIX/lib/libpcsclite.so"* || true

echo "== Done =="
