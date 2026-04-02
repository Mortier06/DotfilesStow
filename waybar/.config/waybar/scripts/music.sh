#!/bin/bash
BARS=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")

STATUS=$(playerctl status 2>/dev/null)
TITLE=$(playerctl metadata title 2>/dev/null)
ARTIST=$(playerctl metadata artist 2>/dev/null)

if [ "$STATUS" != "Playing" ]; then
  echo "  ${ARTIST:+$ARTIST - }${TITLE:-}"
  exit
fi

# Fase bijhouden
PHASE_FILE="/tmp/waybar_eq_phase"
PHASE=$(cat "$PHASE_FILE" 2>/dev/null || echo 0)
PHASE=$(( (PHASE + 1) % 16 ))
echo $PHASE > "$PHASE_FILE"

# Sinus golf berekenen over 8 balkjes
N=8
EQ=""
for i in $(seq 0 $((N-1))); do
  IDX=$(awk "BEGIN {
    pi = 3.14159265
    val = 3.5 + 3.5 * sin(2 * pi * ($i / $N) + 2 * pi * $PHASE / 16)
    idx = int(val)
    if (idx < 0) idx = 0
    if (idx > 7) idx = 7
    print idx
  }")
  EQ+="${BARS[$IDX]}"
done

echo " $EQ  $ARTIST - $TITLE"
