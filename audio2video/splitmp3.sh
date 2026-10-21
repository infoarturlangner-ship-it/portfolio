#!/bin/bash
# Dzieli plik audio na części po 4,5 min (270 s), ostatnia krótsza.
# Użycie: ./splitmp3.sh plik.mp3 [dlugosc_w_sekundach]
# Wynik: plik_1.mp3, plik_2.mp3, ... obok oryginału.

set -e

command -v ffmpeg >/dev/null || { echo "Brak ffmpeg. Zainstaluj: brew install ffmpeg"; exit 1; }
[ -z "$1" ] && { echo "Użycie: $0 plik.mp3 [sekundy]"; exit 1; }

IN="$1"; SEG="${2:-270}"
DIR="$(dirname "$IN")"; BASE="$(basename "$IN")"; NAME="${BASE%.*}"; EXT="${BASE##*.}"

# -c copy: bez rekompresji (bez utraty jakości); cięcie co ~270 s z dokładnością do ramki mp3
ffmpeg -y -hide_banner -loglevel error -i "$IN" -f segment -segment_time "$SEG" \
  -reset_timestamps 1 -c copy -segment_start_number 1 "$DIR/${NAME}_%d.$EXT"

echo "Gotowe, części w: $DIR"
ls "$DIR" | grep -E "^${NAME}_[0-9]+\.$EXT$"
