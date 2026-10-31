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

### Muzyka intro
W sekcji „Eksport” (przy intro) możesz wskazać osobny plik muzyki. Gra od początku intro (zapętlona, jeśli krótsza), miesza się z dźwiękiem z pliku intro albo go zastępuje
(„wycisz oryginalny dźwięk intro”) i wycisza się na końcu intro (domyślnie 1,5 s). Działa też, gdy plik intro nie ma dźwięku. Dotyczy głównego renderu i filmu z momentów.
Plik muzyki musi leżeć w folderze z filmami.

### Dźwięk cięcia: domyślny i własny dla słowa
Nad listą słów jest **„Domyślny dźwięk cięcia”** (plik, głośność %, przesunięcie w sekundach, opcja „także przy cięciach automatycznych”). Gra przy każdym cięciu.
Jeśli przy słowie wskażesz własny dźwięk, ma on pierwszeństwo tylko dla tego słowa; pole **„bez dźwięku”** wyłącza dźwięk dla słowa. Dotyczy też zajawek i filmu z momentów.
Plik dźwięku musi leżeć w folderze z filmami.

### Najlepsze momenty (osobny film)
Sekcja „Najlepsze momenty (osobny film)”:
1. **Instrukcja dla ChatGPT:** ustaw liczbę momentów w wersji dłuższej i krótszej, długość momentu, rodzaj (śmieszne/ciekawe), transkrypcję (film 1/2/oba) i pobierz plik.
   ChatGPT odpowiada JSON-em: `{"momenty":[{"od","do","tytul","krotszy"}]}`; wczytaj go (plik albo wklejony tekst).
2. **Lista momentów:** możesz poprawić czasy i tytuły, dodać/usunąć momenty, oznaczyć „krótszy” i obejrzeć moment (▶).
3. **Tytuły i animacje:** tytuł główny oraz tytuły momentów (plansza przed każdym, domyślnie 2 s). Czcionka z pliku `.ttf/.otf`, wielkość, kolor, obrys,
   tło planszy (rozmyta klatka z momentu albo jednolity kolor) i animacja do wyboru z podglądem: wjazd z dołu + fade, pop, odsłanianie od lewej, odbicie.
   Napisy są rysowane w programie i wklejane do skryptu jako PNG, więc czcionka nie jest potrzebna przy renderze.
4. **Muzyka:** plik z folderu z filmami, zapętlany i przycinany, z wejściem/wyjściem. **Ducking:** gdy w montażu jest głośniejszy dźwięk, muzyka się ścisza,
   gdy cicho (np. na tytułach) wraca do ustawionej głośności („czułość” = od jakiej głośności, „siła” = jak mocno, „powrót” = jak szybko).
5. **Składanie:** opcjonalne intro i outro (pliki z sekcji „Eksport”, doklejane twardo), wersja dłuższa i/lub krótsza.
   „⬇ Pobierz render_momenty.sh” renderuje `momenty_dluzszy.mp4` i `momenty_krotszy.mp4`; „⬇ test” renderuje tytuł i 2 pierwsze momenty.
Opcja **„muzyka z momentów gra od początku intro (dźwięk intro wyciszony)”** (domyślnie włączona): dźwięk z pliku intro jest wyciszony, a muzyka z sekcji momentów
zaczyna się razem z intro i gra bez przerwy przez tytuł i momenty (ducking działa tylko od dźwięku momentów). „Muzyka intro” z sekcji „Eksport” nie dotyczy filmu z momentów.
Momenty to wycinki gotowego głównego montażu: mają te same cięcia (słowa, auto-zmiana), grafiki, efekty przy cięciu i dźwięki. Momenty muszą mieścić się w zakresie „od–do” montażu.
Skrypt wznawia się po błędzie i sprawdza pliki na starcie, tak jak główny render.

### „W tym tygodniu” (skrót z lektorem)

Osobna sekcja w programie. Krótki film-podsumowanie, w którym lektor opowiada o scenach wybranych z głównego montażu.

1. **Instrukcja dla ChatGPT** – przycisk pobiera plik z transkrypcją zakresu „od–do” i poleceniem: wybierz sceny i napisz do każdej akapit narracji. Pole „wstęp” jest opcjonalne: wpisane polecenie dodaje powitanie i najciekawszą scenę, która będzie pod nim widoczna (ChatGPT nie powtarza jej potem w skrócie). Puste pole = same sceny z transkrypcji, bez powitania.
2. **Odpowiedź ChatGPT** (JSON: `wstep`, `momenty` z `od`/`do`/`tekst`) wczytujesz z pliku lub wklejasz. Sceny i teksty można poprawiać w tabeli.
3. **Tekst dla lektora** – przycisk pobiera czysty tekst (akapit na scenę, między akapitami `<break time="1.0s" />`, do wyłączenia), dzielony na kilka plików po ok. 4500 znaków (limit do ustawienia).
4. **Nagranie lektora** – wczytujesz jeden lub kilka plików audio (w kolejności nazw). Program wykrywa przerwy między akapitami i ustawia czas każdej sceny (kolumna „lektor”, można poprawić). Gdy liczba plików równa się liczbie pobranych plików tekstowych, akapity są przypisane do plików; w innym razie plik jest dzielony po najdłuższych przerwach, a gdy przerw jest za mało – proporcjonalnie do liczby słów. Scena jest przedłużana lub skracana do długości swojego akapitu, więc ostatnia scena dopasowuje się do końca lektora.
5. **Dźwięk**: głośność lektora, głośność dźwięku z filmu (0 = wyciszony; dodatkowo przyciszany pod lektorem), opcjonalna muzyka (też ustępuje lektorowi; siła, czułość i powrót jak w „Najlepszych momentach”). Lektor wchodzi po ustawionym czasie (domyślnie 1,5 s), po nim film trwa jeszcze 1 s.
6. **Intro** – film z kanałem alfa jest nakładką na początek (gra raz, nie wydłuża filmu).
7. Cięcia kamer, grafiki, efekt przy cięciu i dźwięk cięcia działają tak samo jak w głównym montażu. Dodatkowo możesz wgrać osobny dźwięk, który gra na granicy akapitów (koniec jednego wątku, początek kolejnego): plik, głośność i przesunięcie (ujemne = chwilę przed zmianą sceny).
8. Instrukcja dla ChatGPT każe pisać narrację w czasie przyszłym („W tym tygodniu … będą walczyć…”) i zwracać się do widzów; w polu „zwrot do widzów” wpisujesz np. „Cześć kooperacjusze!”.

Wynik: `render_tydzien.sh` (z wznawianiem, kontrolą plików i folderem tymczasowym jak pozostałe skrypty) oraz wersja testowa (pierwsze 25 s). Ustawienia sekcji zapisują się w projekcie.

### Głośność intro/outro i wejście dźwięku intro pod zajawką
W sekcji „Eksport”: **głośność muzyki intro i outro** (w %, 100 = bez zmian) oraz **„dźwięk intro wchodzi pod koniec zajawki”** (sekundy, 0 = twarde cięcie).
Przy wartości > 0 dźwięk intro wjeżdża tyle sekund przed jego obrazem, a dźwięk zajawki się wycisza; obraz zmienia się twardo.
Dźwięk intro kończy się wtedy o tyle samo wcześniej niż jego obraz — przy domyślnych 1,5 s wchodzi w tym miejscu dźwięk montażu.

### Tytuły odcinków i transkrypcje części
W tabeli zajawek (sekcja „Zajawka”) przy każdej części jest pole **„tytuł odcinka (nazwa pliku)”**. Wpisany tytuł staje się nazwą wyeksportowanego filmu (znaki niedozwolone w nazwach plików
`\ / : * ? " < > | $` i znak ` zamieniane na myślniki, maks. 120 znaków); pusty tytuł = nazwa domyślna (`montaz_cz01.mp4`). Pod polem widać, jaka nazwa powstanie.
Jeśli dwie części mają ten sam tytuł, druga dostaje końcówkę `_czNN`. Przycisk **„⬇ transkrypcja”** pobiera plik tekstowy z tytułem (tak jak go wpisałeś) i samymi zdaniami (bez czasów)
z głównego montażu tej części (bez zajawki i intro), o nazwie takiej jak film (`Tytuł.txt`). **„⬇ pobierz wszystkie transkrypcje”** pobiera pliki wszystkich części po kolei.
Transkrypcję bierze z jednego filmu (wybór: film 1 / film 2). Tytuły zapisują się w projekcie.

### Wybór zajawek przez ChatGPT
W sekcji „Zajawka” po ustawieniu podziału na części:
1. ustaw długość zajawki (od–do), wybierz, z którego filmu ma być transkrypcja, dopisz opcjonalny kontekst;
2. **„Pobierz instrukcję dla ChatGPT”** zapisuje `instrukcja_chatgpt.txt`: zadanie, zasady wyboru, tabelę części (czasy) i transkrypcję
   każdej części z czasami (oś czasu montażu = czas filmu 1). Wgraj plik do ChatGPT;
3. ChatGPT odpowiada JSON-em z jedną zajawką na część (`czesc`, `od`, `do`, `powod`);
4. wczytaj odpowiedź (plik `.json`/`.txt` albo wklej tekst) — czasy wpiszą się w tabelę zajawek. Program ostrzega, gdy zakres wychodzi poza część.
Czasy z napisów YouTube są przybliżone (linie, nie słowa), więc każdą zajawkę obejrzyj przyciskiem „▶ podgląd zajawki”.
Napisy automatyczne YouTube mają powtarzające się linie („roll-up”); program wykrywa to i liczy każdą linię raz (dotyczy też wyszukiwania słów).

### Słowa: akcja „z tej transkrypcji” i tolerancja
Akcja **„przejdź na film z tej transkrypcji”** (domyślna dla nowych słów) przełącza na film, z którego pochodzi transkrypcja z trafieniem.
Pole **„ignoruj to samo słowo z drugiej transkrypcji przez … s”** (domyślnie 4 s) pomija to samo słowo wykryte w drugim filmie tuż po pierwszym
(opóźnienie czatu), więc obraz nie wraca na poprzedni film. Powtórki w tej samej transkrypcji (np. „kontakt, kontakt”) zostają.
Liczba pominiętych trafień jest widoczna w podsumowaniu nad listą trafień. 0 = wyłączone.

### Efekt przy cięciu
Sekcja „Efekt przy cięciu” (domyślnie wyłączona):
- **rozjaśnienie** po każdym cięciu z płynnym powrotem do naturalnych kolorów; suwaki siły i czasu (ease-out);
- **wideo z kanałem alfa**, które leży nad montażem i startuje od początku przy każdym cięciu. Zalecany format: **.mov ProRes 4444** (render sprawdzony
  z ProRes 4444 i WebM VP9 z alfa). Przeglądarka może go nie odtworzyć w podglądzie (Chrome zwykle nie obsługuje ProRes) — wtedy podgląd pokazuje
  samo rozjaśnienie, a nakładka pojawia się w renderze. Plik na pełny kadr, w proporcjach rozmiaru wyjściowego.
Efekty nie dotyczą pierwszego ujęcia części ani intro/outro.

### Zajawka „W dzisiejszym odcinku”
Sekcja „Zajawka”: dla każdej części osobny zakres (od–do, czas filmu 1) gotowego montażu, który trafia na początek pliku. Kolejność w pliku:
zajawka → intro z pliku → montaż → outro. Zajawka ma te same cięcia, grafiki, efekty i dźwięki co montaż. Opcjonalne wideo z alfa
(napis „W dzisiejszym odcinku”) jest nałożone na zajawkę od jej początku. Przycisk **„▶ podgląd zajawki”** odtwarza wybrany zakres,
a **„⬇ test: zajawka + intro + 10 s”** pobiera skrypt `render_test_czNN.sh`, który renderuje tylko `test_czNN.mp4`
(zajawka + intro + pierwsze 10 s tej części, bez outro; własny folder roboczy `_segtest`, więc nie rusza głównego renderu).

### Automatyczna zmiana kamery
W sekcji 3 zaznacz **„automatyczna zmiana kamery co … s"**. Jeśli przez podany czas żadne słowo nie przełączy obrazu,
program przełączy go sam na drugi film (licznik zaczyna się od nowa po każdej zmianie, także tej od słowa).
Odznacz pole, żeby zmieniały się tylko słowa. Do automatycznych zmian nie są dogrywane efekty dźwiękowe (należą do słów).

### Przenikanie dźwięku przy intro i outro
W sekcji „Eksport" ustawiasz długość nakładania (domyślnie 1,5 s; 0 = twarde cięcie dźwięku).
- **Intro → montaż:** intro gra do samego końca, a pod jego końcówką wjeżdża dźwięk montażu. Dźwięk jest brany ze źródła
  z chwili tuż przed początkiem zakresu, więc nie rozjeżdża się z obrazem (jeśli zakres zaczyna się przy samym początku filmu, nakładka jest krótsza).
- **Montaż → outro:** dźwięk outro zaczyna się wcześniej niż jego obraz, a dźwięk montażu się wycisza.
  Ponieważ outro nie ma materiału „sprzed siebie", jego dźwięk kończy się o tyle samo wcześniej niż obraz outro.

### Podział na części
W sekcji „Eksport" pole **„podziel na części"** dzieli gotowy montaż na N osobnych plików (np. kilka odcinków z jednego długiego materiału).
Tabela pokazuje zakres, długość każdej części oraz długość razem z intro/outro.
- „tnij przy najbliższym cięciu" — części są zbliżone długością, ale granica wypada na istniejącym cięciu (nie przecina ujęcia);
- „dokładnie po równo" — części mają równą długość, granica może wypaść w środku ujęcia.
- Zaznaczone „intro i outro w każdej części" dodaje je do każdego pliku; odznaczone = intro tylko w pierwszej części, outro tylko w ostatniej.
Pliki mają nazwy `nazwa_cz01.mp4`, `nazwa_cz02.mp4` itd. Efekty dźwiękowe liczone są osobno dla każdej części.
Skrypt kasuje pliki tymczasowe po każdej części, więc nie potrzebuje miejsca na cały materiał naraz.
EDL jest zawsze dla całego montażu (intro raz na początku, outro raz na końcu).

### Wznawianie renderu
`render.sh` na starcie sprawdza, czy wszystkie potrzebne pliki (filmy, intro, outro, dźwięki, grafiki) leżą w folderze. Jeśli czegoś brakuje,
wypisuje `BRAK PLIKU: …` i kończy od razu, zanim zacznie kodować.
Gotowe fragmenty leżą w folderze `_seg/`. Po przerwaniu (Ctrl+C) albo błędzie wystarczy uruchomić `bash render.sh` jeszcze raz: skrypt pominie
fragmenty i części, które są już gotowe, i dokończy resztę. Fragmenty są unieważniane, gdy zmienisz ustawienia kodowania (rozdzielczość, fps, enkoder,
zakres, słowa, grafiki) — wtedy zaczyna od nowa. Jeśli podmienisz sam plik wideo, nie zmieniając jego nazwy, usuń folder `_seg` ręcznie.
Po udanym renderze `_seg` jest kasowany.

Dodatkowo: eksport EDL do DaVinci Resolve oraz zapis/wczytanie projektu (markery i ustawienia).

## Uwagi

- Render robi osobne krótkie pliki tymczasowe `_seg/` (usuwane na końcu), potem sklejenie — dzięki temu
  jest szybki, cięcia są co do klatki i nie zjada pamięci. Wideo kodowane jest raz.
- Wariant „VideoToolbox" jest kilka razy szybszy na Macu, ale odrobinę gorszy jakościowo.
- Filmy o różnych rozmiarach/fps są wyrównane do ustawionej rozdzielczości i fps.
