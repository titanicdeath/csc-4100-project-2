#!/bin/bash
# package.sh - Build, test, and package CSC 4100 Project 2 for submission.
#
# Run from the repo directory. Produces:
#   ~/Desktop/Simmons_Project2/
#       pintos_simmons.tar.gz       (the whole Pintos tree)
#       DESIGNDOC                   (standalone copy)
#       screenshots/
#           grade_output.txt        (full make grade log)
#           grade_summary.txt       (just the score table)
#   ~/Desktop/Simmons_Project2.zip  (final upload bundle)

set -e

REPO="$PWD"
PINTOS="/home/os/pintos"
THREADS="$PINTOS/src/threads"
DEVICES="$PINTOS/src/devices"
BUILD="$THREADS/build"
OUT="$HOME/Desktop/Simmons_Project2"

# Sanity checks.
for f in timer.c thread.h thread.c DESIGNDOC; do
    if [ ! -f "$f" ]; then
        echo "ERROR: $f not found. Run from the repo root." >&2
        exit 1
    fi
done

if [ ! -d "$THREADS" ]; then
    echo "ERROR: Pintos tree not found at $PINTOS." >&2
    exit 1
fi

echo "=== Step 1/6: Pulling latest from git ==="
git pull

echo
echo "=== Step 2/6: Copying authored files into Pintos tree ==="
cp timer.c   "$DEVICES/timer.c"
cp thread.h  "$THREADS/thread.h"
cp thread.c  "$THREADS/thread.c"
cp DESIGNDOC "$THREADS/DESIGNDOC"

echo
echo "=== Step 3/6: Building Pintos ==="
cd "$THREADS"
make

echo
echo "=== Step 4/6: Running make grade (this takes a few minutes) ==="
cd "$BUILD"
rm -f grade
make grade > "$REPO/grade_output.tmp" 2>&1 || true   # don't abort on test failures

echo
echo "=== Step 5/6: Assembling submission folder ==="
rm -rf "$OUT" "$OUT.zip"
mkdir -p "$OUT/screenshots"

# Pintos tree archive.
echo "  Creating pintos_simmons.tar.gz ..."
cd /home/os
tar -czf "$OUT/pintos_simmons.tar.gz" pintos/

# Standalone DESIGNDOC.
cp "$THREADS/DESIGNDOC" "$OUT/DESIGNDOC"

# Grade output (full + summary-only).
cp "$REPO/grade_output.tmp" "$OUT/screenshots/grade_output.txt"
grep -A 60 "TOTAL TESTING SCORE" "$REPO/grade_output.tmp" \
    > "$OUT/screenshots/grade_summary.txt" \
    || echo "WARNING: could not find score summary in grade output" >&2
rm -f "$REPO/grade_output.tmp"

echo
echo "=== Step 6/6: Zipping for upload ==="
cd "$HOME/Desktop"
zip -rq Simmons_Project2.zip Simmons_Project2/

echo
echo "================================================================"
echo "Done. Ready for upload:"
echo "  $HOME/Desktop/Simmons_Project2.zip"
echo
echo "Score summary:"
echo "----------------------------------------------------------------"
grep -A 12 "Rubric.alarm" "$OUT/screenshots/grade_summary.txt" || true
echo "----------------------------------------------------------------"
echo
echo "Drop your screenshot PNGs into:"
echo "  $OUT/screenshots/"
echo "then re-zip with:"
echo "  cd ~/Desktop && rm Simmons_Project2.zip && zip -rq Simmons_Project2.zip Simmons_Project2/"
echo "================================================================"
