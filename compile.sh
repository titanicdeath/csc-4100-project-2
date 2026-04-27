#!/bin/bash
set -e

PINTOS=/home/os/path/to/pintos    # ← fills in once we know

# Copy authored files into the source tree
cp timer.c     "$PINTOS/src/devices/timer.c"
cp thread.h    "$PINTOS/src/threads/thread.h"
cp thread.c    "$PINTOS/src/threads/thread.c"
cp DESIGNDOC   "$PINTOS/src/threads/DESIGNDOC"

# Build
cd "$PINTOS/src/threads"
make

echo "Build complete. To run tests: cd $PINTOS/src/threads/build && make grade"