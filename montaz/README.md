# Montaż na słowo

Dwa filmy → cięcia (przełączanie obrazu **i** dźwięku) przy każdym wystąpieniu wybranego słowa → mp4.
`montaz.html` to jeden plik, otwierasz dwuklikiem (Chrome/Safari), działa offline, filmy nie opuszczają komputera.

## Jednorazowa instalacja (Mac)

```
brew install ffmpeg whisper-cpp
# model (polski OK):
curl -L -o ggml-large-v3-turbo.bin https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3-turbo.bin
```

## Transkrypcja (dla każdego filmu)

```
ffmpeg -i film1.mp4 -ar 16000 -ac 1 -c:a pcm_s16le audio1.wav
whisper-cli -m ggml-large-v3-turbo.bin -f audio1.wav -l pl -ml 1 -sow -ojf -of film1
```
Powstaje `film1.json` (timing per słowo). To samo dla filmu 2. Zwykłe `.srt`/`.vtt` też się wczytają
(timing linijkowy, mniej precyzyjny). Jeśli `whisper-cli` nie istnieje, spróbuj `whisper-cpp`.

## Użycie

1. Wczytaj oba filmy i transkrypcje.
2. **Kalibracja:** znajdź to samo zdarzenie w obu filmach (klaśnięcie, początek słowa), zatrzymaj klatkę
   (przyciski ±1 klatka) i kliknij „Ustaw M1/M2". Offset = M2 − M1.
3. Wpisz słowo (szukanie po fragmencie, bez polskich znaków i wielkości liter), wybierz w czyjej transkrypcji
   szukać, od którego filmu zaczynać i minimalną długość ujęcia. Niechciane trafienia odznacz.
4. „Podgląd montażu" pokazuje dokładnie to, co wyjdzie z renderu.
5. Skopiuj skrypt / pobierz `render.sh`, uruchom w folderze z oryginalnymi plikami: `bash render.sh`.
   (Nazwy plików w skrypcie = nazwy wczytanych filmów.)

Dodatkowo: eksport EDL do DaVinci Resolve oraz zapis/wczytanie projektu (markery i ustawienia).

## Uwagi

- Render robi osobne krótkie pliki tymczasowe `_seg/` (usuwane na końcu), potem sklejenie — dzięki temu
  jest szybki, cięcia są co do klatki i nie zjada pamięci. Wideo kodowane jest raz.
- Wariant „VideoToolbox" jest kilka razy szybszy na Macu, ale odrobinę gorszy jakościowo.
- Filmy o różnych rozmiarach/fps są wyrównane do ustawionej rozdzielczości i fps.
