#!/bin/bash
# Zamienia plik audio na film 1080x1920 (pion): czarne tło, biały tytuł na środku.
# Użycie: ./audio2video.sh plik.mp3 [plik2.wav ...] [-t "Własny tytuł"]
# Bez -t tytułem jest nazwa pliku.

set -e

if ! command -v ffmpeg >/dev/null; then
  echo "Brak ffmpeg. Zainstaluj: brew install ffmpeg"; exit 1
fi

TITLE=""
FILES=()
while [ $# -gt 0 ]; do
  case "$1" in
    -t) TITLE="$2"; shift 2;;
    *) FILES+=("$1"); shift;;
  esac
done

[ ${#FILES[@]} -eq 0 ] && { echo "Użycie: $0 plik.mp3 [-t \"Tytuł\"]"; exit 1; }

# font: macOS lub Linux
for F in /System/Library/Fonts/Helvetica.ttc /Library/Fonts/Arial.ttf /System/Library/Fonts/Supplemental/Arial.ttf /usr/share/fonts/truetype/dejavu/DejaVuSans.ttf; do
  [ -f "$F" ] && FONT="$F" && break
done

for IN in "${FILES[@]}"; do
  BASE="$(basename "$IN")"; NAME="${BASE%.*}"
  T="${TITLE:-$NAME}"
  OUT="$(dirname "$IN")/$NAME.mp4"
  TXT="$(mktemp)"
  # zawijanie tekstu do ~16 znaków w linii
  printf '%s' "$T" | fold -s -w 16 > "$TXT"

  ffmpeg -y -hide_banner -loglevel error -stats \
    -f lavfi -i "color=c=black:s=1080x1920:r=30" -i "$IN" \
    -vf "drawtext=fontfile='$FONT':textfile='$TXT':fontcolor=white:fontsize=90:line_spacing=20:text_align=center:x=(w-text_w)/2:y=(h-text_h)/2" \
    -c:v libx264 -preset medium -tune stillimage -pix_fmt yuv420p \
    -c:a aac -b:a 192k -shortest -movflags +faststart "$OUT"
  rm -f "$TXT"
  echo "Gotowe: $OUT"
done
