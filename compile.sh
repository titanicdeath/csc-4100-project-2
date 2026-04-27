#!/bin/bash
# Build script for CSC 4100 Project 2 - Pintos Alarm Clock.
# Copies authored files into the Pintos source tree, then builds.
# Run from the repo directory.

set -e

PINTOS="/home/os/pintos"
THREADS="$PINTOS/src/threads"
DEVICES="$PINTOS/src/devices"

# Sanity check: are we in the right place?
for f in timer.c thread.h thread.c DESIGNDOC; do
    if [ ! -f "$f" ]; then
        echo "ERROR: $f not found. Run this script from the repo root." >&2
        exit 1
    fi
done

# Sanity check: does the Pintos tree exist where we expect?
if [ ! -d "$THREADS" ]; then
    echo "ERROR: Pintos tree not found at $PINTOS." >&2
    echo "Edit PINTOS at the top of this script if it lives elsewhere." >&2
    exit 1
fi

echo "Copying authored files into Pintos tree..."
cp timer.c   "$DEVICES/timer.c"
cp thread.h  "$THREADS/thread.h"
cp thread.c  "$THREADS/thread.c"
cp DESIGNDOC "$THREADS/DESIGNDOC"

echo "Building..."
cd "$THREADS"
make

echo
echo "Build succeeded."
echo "To run all alarm tests:"
echo "  cd $THREADS/build && make grade"
echo "To run a single test:"
echo "  cd $THREADS/build && make tests/threads/alarm-multiple.result"