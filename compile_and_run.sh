#!/bin/bash
set -e

# Default to main.f95 and matrix.f95 if no arguments provided
MAIN_FILE="${1:-main.f95}"
MODULE_FILE="${2:-matrix.f95}"

MAIN_BASE="${MAIN_FILE%.*}"
MODULE_BASE="${MODULE_FILE%.*}"

echo "==> Compiling module: $MODULE_FILE"
gfortran -Wall -Wno-tabs -O2 -c "$MODULE_FILE"

echo "==> Compiling main program: $MAIN_FILE"
gfortran -Wall -Wno-tabs -O2 -c "$MAIN_FILE"

echo "==> Linking object files into executable 'main'"
gfortran "${MAIN_BASE}.o" "${MODULE_BASE}.o" -o main

echo "==> Program successfully compiled."
echo "==> Running './main'..."
echo "----------------------------------------"
./main
