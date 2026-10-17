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
3. Dodaj jedno lub kilka słów (przycisk „+ dodaj słowo"). Szukanie jest po fragmencie, bez polskich znaków
   i wielkości liter. Każde słowo ma własne ustawienia: w której transkrypcji szukać oraz **akcję** —
   „przełącz na drugi film" albo „przejdź na film 1/2". Np. `megalodon` → przełącz, `koniec` → przejdź na film 1.
   Ustaw też, od którego filmu zaczynać, i minimalną długość ujęcia. Niechciane trafienia odznacz.
   Trafienia ze wszystkich słów łączą się na jednej osi czasu; akcja „przejdź na film X", gdy już jesteś na X, nic nie zmienia.
4. „Podgląd montażu" pokazuje dokładnie to, co wyjdzie z renderu.
5. Skopiuj skrypt / pobierz `render.sh`, uruchom w folderze z oryginalnymi plikami: `bash render.sh`.
   (Nazwy plików w skrypcie = nazwy wczytanych filmów.)

### Dźwięk w cięciu, intro i outro
- Przy każdym słowie możesz wskazać **plik dźwiękowy** (mp3/wav/m4a), jego głośność w % i przesunięcie w sekundach
  (wartość ujemna = dźwięk zaczyna się przed cięciem). Efekt jest dogrywany na wierzch audio w momencie faktycznej zmiany obrazu.
  W podglądzie słychać efekt przy cięciu (przesunięcie działa, głośność do 100%); w renderze głośność może być większa.
- W sekcji „Eksport" możesz wybrać **intro** i **outro** (filmy dołączane na początku i końcu). Nie ma ich w podglądzie,
  są w renderze i w EDL. Są dopasowywane do rozdzielczości i fps montażu; jeśli nie mają dźwięku, dostają ciszę.
- Pliki dźwięków, intro i outro muszą leżeć w tym samym folderze co filmy i `render.sh`.

### Grafiki (nakładki)
Sekcja „Grafiki": dodajesz obrazki (PNG z przezroczystością, JPG), przypisujesz do filmu 1, filmu 2 lub obu i ustawiasz pozycję (x, y w % kadru),
szerokość (% szerokości kadru) i krycie. Grafika jest widoczna przez cały czas, gdy dany film jest w kadrze, bez animacji.
W „Podgląd montażu" możesz ją przeciągać myszą; przycisk „pokaż w podglądzie" przewija do ujęcia z danego filmu.
Plik graficzny musi leżeć w folderze z filmami. Intro i outro nie dostają nakładek, EDL ich nie zawiera.
Podgląd ma proporcje rozmiaru wyjściowego (pola rozdzielczości w sekcji „Eksport").

### Zakres montażu
Pola „od" i „do" w sekcji 3 przyjmują czas w formacie `1:12:05`, `72:05` albo zwykłe sekundy (`4325`). Przyciski „ustaw na bieżący"
wpisują w nie aktualny czas filmu 1 (np. ustaw film w odpowiednim miejscu, kliknij przycisk).

### Podział na części
W sekcji „Eksport" pole **„podziel na części"** dzieli gotowy montaż na N osobnych plików (np. kilka odcinków z jednego długiego materiału).
Tabela pokazuje zakres, długość każdej części oraz długość razem z intro/outro.
- „tnij przy najbliższym cięciu" — części są zbliżone długością, ale granica wypada na istniejącym cięciu (nie przecina ujęcia);
- „dokładnie po równo" — części mają równą długość, granica może wypaść w środku ujęcia.
- Zaznaczone „intro i outro w każdej części" dodaje je do każdego pliku; odznaczone = intro tylko w pierwszej części, outro tylko w ostatniej.
Pliki mają nazwy `nazwa_cz01.mp4`, `nazwa_cz02.mp4` itd. Efekty dźwiękowe liczone są osobno dla każdej części.
Skrypt kasuje pliki tymczasowe po każdej części, więc nie potrzebuje miejsca na cały materiał naraz.
EDL jest zawsze dla całego montażu (intro raz na początku, outro raz na końcu).

Dodatkowo: eksport EDL do DaVinci Resolve oraz zapis/wczytanie projektu (markery i ustawienia).

## Uwagi

- Render robi osobne krótkie pliki tymczasowe `_seg/` (usuwane na końcu), potem sklejenie — dzięki temu
  jest szybki, cięcia są co do klatki i nie zjada pamięci. Wideo kodowane jest raz.
- Wariant „VideoToolbox" jest kilka razy szybszy na Macu, ale odrobinę gorszy jakościowo.
- Filmy o różnych rozmiarach/fps są wyrównane do ustawionej rozdzielczości i fps.
