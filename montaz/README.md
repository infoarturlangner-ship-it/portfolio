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

Oprócz intro można wgrać **nakładkę w pętli** (film z alfą): po ustawionym czasie (domyślnie 8 s) włącza się na najwyższej warstwie i powtarza się w pętli do końca skrótu. Długość pętli program odczytuje z pliku.

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

### Nakładki wideo na słowa (kanał alfa)

Sekcja „Nakładki wideo na słowa”: dodajesz wiersz (słowo, z której transkrypcji, plik .mov/.webm z alfą). Gdy słowo pada w materiale, film gra raz na najwyższej warstwie, na całym kadrze, od początku do końca (długość program odczytuje z pliku, można poprawić). Nakładka trwa ciągle także przez cięcia kamer i nie powtarza się, dopóki trwa. Można dodać kilka nakładek. Działa w montażu, zajawce, momentach i skrócie „W tym tygodniu”. Dźwięk nakładki nie jest używany, a podgląd w przeglądarce jej nie pokazuje (widać ją w renderze). Ustawienia zapisują się w projekcie.

### Teksty z animacją na początku filmu

W zakładce „Grafiki i efekty” sekcja „Teksty z animacją na początku filmu”. Dodajesz teksty (przyciski „+ nagłówek (Burbank)” i „+ komunikat (Inter)”), a one pojawiają się po kolei na początku głównego montażu, czyli po intro i zajawce, i znikają po ustawionym czasie. Każdy tekst ma: treść (kilka linii), czcionkę, wielkość, kolor, obrys, animację (wjazd, pop, odsłanianie, odbicie), czas wyświetlania, przerwę przed sobą i położenie pionowe (% wysokości); ↑/↓ zmieniają kolejność, „▶ podgląd” pokazuje animację. „Pierwszy tekst po (s)” ustawia opóźnienie od początku montażu, a „w każdej części filmu” powtarza teksty na początku każdego odcinka.

- **Inter** (komunikaty, np. „Wszelkie podobieństwo do prawdziwych osób… jest przypadkowe”) jest wbudowany w program, z polskimi znakami, w grubości zwykłej i pogrubionej.
- **Burbank Big Regular** (nagłówki, np. „Subskrybuj”) wgrywasz z własnego pliku .ttf/.otf, bo to czcionka na licencji Epic Games. Bez pliku nagłówki są pisane zastępczą, grubą czcionką. Plik czcionki jest zapamiętywany razem z projektem jak inne pliki.
- Teksty nie pojawiają się w zajawce, momentach, „W tym tygodniu” ani w shortach, tylko w głównym montażu. Są renderowane skryptem jako klipy z kanałem alfa (ten sam mechanizm animacji co tytuły momentów) i nakładane na obraz.

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

### Podział na odcinki wg AI

W sekcji „Eksport” (przy „podziel na części”) jest drugi sposób wyznaczania granic: **wg AI**. ChatGPT wskazuje, gdzie zakończyć każdy odcinek, żeby kończył się w sensownym momencie (puenta, koniec wątku, naturalna przerwa), a nie w środku zdania czy akcji.

1. Ustaw liczbę odcinków („podziel na części”, co najmniej 2) i kliknij „Pobierz instrukcję (podział na odcinki)”. Dla każdej granicy program wyznacza okno poszukiwań (miejsce równego podziału ± kilka minut, domyślnie 4) i wysyła ChatGPT tylko transkrypcję z tych okien, więc instrukcja jest krótka.
2. Odpowiedź ChatGPT to JSON `{"podzial":[{"koniec":"0:45:10","powod":"…"}]}` (liczba wpisów = odcinki minus 1). Wczytujesz ją z pliku albo wklejasz.
3. Program dodaje „po puencie” (domyślnie 1,5 s), żeby nie ściąć ostatniego zdania, przełącza „tnij” na „wg AI” i dzieli dokładnie w tych punktach. Granice można poprawić w tabeli (czas, ▶ podgląd, usuń). Intro/outro, zajawki i tytuły działają jak przy zwykłym podziale. Granice zapisują się w projekcie.

### Podział na części
W sekcji „Eksport" pole **„podziel na części"** dzieli gotowy montaż na N osobnych plików (np. kilka odcinków z jednego długiego materiału).
Tabela pokazuje zakres, długość każdej części oraz długość razem z intro/outro.
- „tnij przy najbliższym cięciu" — części są zbliżone długością, ale granica wypada na istniejącym cięciu (nie przecina ujęcia);
- „dokładnie po równo" — części mają równą długość, granica może wypaść w środku ujęcia.
- Zaznaczone „intro i outro w każdej części" dodaje je do każdego pliku; odznaczone = intro tylko w pierwszej części, outro tylko w ostatniej.
Pliki mają nazwy `nazwa_cz01.mp4`, `nazwa_cz02.mp4` itd. Efekty dźwiękowe liczone są osobno dla każdej części.
Skrypt kasuje pliki tymczasowe po każdej części, więc nie potrzebuje miejsca na cały materiał naraz.
EDL jest zawsze dla całego montażu (intro raz na początku, outro raz na końcu).

### Shorty (pionowe 9:16, z komentarzem lektora)

Zakładka „Shorty”. Powstaje osobny plik mp4 (1080×1920) na każdy short.

1. **Instrukcja dla ChatGPT**: liczba shortów, długość (np. 20–50 s), maks. długość wstawki, wybór „najśmieszniejsze / najciekawsze / oba”. ChatGPT zwraca dla każdego shorta zakres „od–do”, tytuł i listę krótkich wstawek lektora z czasem „kiedy” (docinki w trakcie rozmowy, opcjonalnie puenta na końcu). Wstawek może być 0.
2. **Lista shortów**: czasy, tytuły i teksty możesz poprawiać, dodawać i usuwać; „▶” podgląda fragment lub wstawkę. Przy każdym shorcie jest pole „outro”.
3. **Tekst dla lektora**: jeden plik, każda wstawka to akapit, między akapitami `<break time="2.0s" />` (długość do ustawienia). Kolejność: shorty od góry, wstawki po kolei.
4. **Nagranie lektora**: wczytujesz jeden plik z ElevenLabs (albo tyle plików, ile pobrałeś). Program wykrywa przerwy, wycina każdą kwestię i wstawia ją w klipie w czasie „kiedy”, bez nakładania na poprzednią wstawkę. Jeśli kwestia kończy się po końcu zakresu (puenta), klip jest wydłużony o jej długość (obraz płynie dalej).
5. **Dźwięk**: głośność lektora, głośność dźwięku z gry (ściszany dodatkowo pod lektorem) i opcjonalna muzyka (też ustępuje lektorowi).
6. **Kadr**: film 16:9 jest skalowany do szerokości kadru i stoi pośrodku na czarnym tle. Na wierzchu leży nakładka: PNG 1080×1920 albo wideo z alfą (zapętlone od początku każdego shorta).
7. **Outro** (opcjonalne, doklejone na końcu, z własnym dźwiękiem): jego dźwięk wchodzi łagodnie w ostatnich sekundach shorta (ustawiana liczba sekund), a dźwięk shorta wtedy cichnie. Na początku shortów nie ma intra. Plik outro musi mieć ścieżkę dźwiękową.

**Podgląd shorta** (w zakładce, przycisk „▶ short” przy każdym shorcie): pionowy ekran 9:16 z filmem na czarnym tle, grafikami z głównego montażu, Twoją nakładką, wstawkami lektora w ich momentach (z nagrania) i przyciszaniem dźwięku z gry pod lektorem. Podgląd nie zawiera outro, muzyki, efektu alfa przy cięciu ani nakładek na słowa, a nakładka w formacie .mov (ProRes) może się w przeglądarce nie odtworzyć (render ją użyje). Przycisk „▶ film” odtwarza surowy fragment poziomo w zakładce „Podgląd i markery”.

Wszystko z głównego montażu działa w shortach: cięcia kamer, dźwięki cięć, błysk, grafiki (nakładki), efekt alfa przy cięciu i nakładki wideo na słowa. Są nakładane na obszar filmu 16:9 (pozycje i rozmiary w % tak jak w głównym montażu), a Twoja nakładka 9:16 leży na całym kadrze, na wierzchu.

**Lektor jest opcjonalny:** bez wczytanego nagrania render powstaje bez wstawek (dźwięk z gry 100%, długość shorta = „od–do”). Wynik: `render_shorty.sh` (wznawianie, kontrola plików i fragmentów) oraz wersja testowa z pierwszym shortem.

### Montaż AI (ChatGPT decyduje, którą kamerę pokazać)

Zakładka „Montaż AI” jest aktywna po wczytaniu obu filmów i obu transkrypcji oraz ustawieniu zakresu „od–do”. Synchronizacja M1/M2 jest zalecana (program ostrzega, jeśli jej brak).

1. **Instrukcje dla ChatGPT.** Program sam dopasowuje zdania z transkrypcji filmu 1 i filmu 2 (po tekście, z tolerancją na błędy rozpoznawania i polskie znaki) i oznacza je na wspólnej osi czasu: `F1→F2 +1.2s` (zdanie padło w transkrypcji filmu 1 wcześniej, więc mówi osoba z kamery 1), `F2→F1`, `F1` / `F2` (zdanie tylko w jednej transkrypcji), `F1=F2` (różnica zbyt mała). ChatGPT dostaje te oznaczenia plus zasady: domyślnie pokazuj kamerę osoby mówiącej, ale uwzględniaj kontekst rozmowy (reakcje, odpowiedzi, długie wypowiedzi), nie przełączaj częściej niż co minimalną długość ujęcia (domyślnie 3 s). Możesz podać imiona osób z filmu 1 i 2 i kontekst. Instrukcje są dzielone na części po ok. 20 minut (do ustawienia), bo całość nie zmieści się w jednej wiadomości; przycisk pobiera wszystkie naraz, a każdą część można pobrać osobno.
2. **Odpowiedzi.** Każda odpowiedź to JSON `{"przelaczenia":[{"t":"0:12:03","kamera":1},…]}`. Wczytujesz je z plików (kilka naraz) albo wklejasz po jednej; program łączy je w jedną listę i ostrzega o częściach bez przełączeń.
3. **Lista przełączeń** jest edytowalna (czas, kamera, podgląd, usuwanie, dodawanie). Parametr „wyprzedzenie cięcia” (domyślnie 0,3 s) przesuwa każde cięcie tuż przed początek wypowiedzi.
4. **Tryb montażu** przełączasz w zakładce „Słowa i cięcia” (na słowa kluczowe / montaż AI; tryby się wykluczają). Wybrany tryb dotyczy całego programu: podziału na części, intro/outro, zajawki, momentów, shortów i „W tym tygodniu”. Efekty przy cięciu, błysk i domyślny dźwięk cięcia działają w obu trybach. Lista przełączeń zapisuje się w projekcie.

5. **Brak statyczności i sprawiedliwy podział.** Instrukcja każe ChatGPT przełączać kamerę mniej więcej co N s (domyślnie 35, pole „maks. czas jednej kamery bez zmiany”), gdy fabuła nie wymusza cięcia, i dbać o zbliżony czas obu kamer (ok. 50/50). Przycisk **„Uzupełnij i wyrównaj”** robi to też lokalnie: dokłada przerywniki drugiej kamery w zbyt długich ujęciach (najchętniej na początku wypowiedzi), dobierając odstęp (±10 s od ustawionego) i długość przerywników tak, żeby czas kamer w całym montażu był sprawiedliwy (ok. 50/50, tolerancja ±5 punktów) bez nadmiaru cięć. Można cofnąć.

ChatGPT widzi tylko transkrypcje, nie obraz, więc decyzje opierają się na rozmowie.

### Pamięć wczytanych plików i projekt

Opcja „zapamiętuj wczytane pliki w tej przeglądarce” (sekcja „Eksport”, domyślnie włączona) kopiuje każdy wczytany plik (filmy, transkrypcje, grafiki, dźwięki, muzykę, czcionki, nakładki i pętle z alfą, nagrania lektora, intro/outro) do pamięci przeglądarki (IndexedDB). „Zapisz projekt” zapisuje do pliku .json listę tych plików, a po „wczytaj projekt” program sam odtwarza je z pamięci przeglądarki i uzupełnia pola, tak jakbyś wczytał je ręcznie, bez ponownego wybierania. Pliki z danymi (odpowiedzi ChatGPT, lista przełączeń AI, shortów, scen) zapisują się w samym projekcie. Zapamiętane pliki zajmują tyle miejsca na dysku, ile same pliki (także filmy); przycisk „Wyczyść zapamiętane pliki” je usuwa. Pamięć działa tylko w tej samej przeglądarce i na tym samym komputerze: na innym komputerze lub po wyczyszczeniu danych przeglądarki pliki trzeba wczytać ponownie (program pokaże, których brakuje).

### Zakładki

Program jest podzielony na poziome zakładki (u góry, przypięte do góry strony): Pliki, Podgląd i markery, Słowa i cięcia, Grafiki i efekty (grafiki, efekt przy cięciu, nakładki wideo na słowa), Zajawka, Najlepsze momenty, W tym tygodniu, Shorty, Eksport i skrypt. Przycisk „▶” przy scenach/momentach/zajawkach sam przełącza na zakładkę „Podgląd i markery”. Program pamięta ostatnią otwartą zakładkę.

### Wznawianie renderu
`render.sh` na starcie sprawdza, czy wszystkie potrzebne pliki (filmy, intro, outro, dźwięki, grafiki) leżą w folderze. Jeśli czegoś brakuje,
wypisuje `BRAK PLIKU: …` i kończy od razu, zanim zacznie kodować.
Gotowe fragmenty leżą w folderze `_seg/`. Po przerwaniu (Ctrl+C) albo błędzie wystarczy uruchomić `bash render.sh` jeszcze raz: skrypt pominie
fragmenty i części, które są już gotowe, i dokończy resztę. Fragmenty są unieważniane, gdy zmienisz ustawienia kodowania (rozdzielczość, fps, enkoder,
zakres, słowa, grafiki) — wtedy zaczyna od nowa. Jeśli podmienisz sam plik wideo, nie zmieniając jego nazwy, usuń folder `_seg` ręcznie.
Po udanym renderze `_seg` jest kasowany.

Dodatkowo: eksport EDL do DaVinci Resolve oraz zapis/wczytanie projektu (markery i ustawienia).


Po zakodowaniu każdy fragment jest sprawdzany (musi mieć klatki obrazu). Pusty albo uszkodzony fragment zatrzymuje skrypt z komunikatem „BŁĄD: fragment … jest pusty lub uszkodzony”, zamiast po cichu ucinać film. Po poprawce wystarczy uruchomić skrypt jeszcze raz (usunie uszkodzony fragment i zakoduje go od nowa).
## Uwagi

- Render robi osobne krótkie pliki tymczasowe `_seg/` (usuwane na końcu), potem sklejenie — dzięki temu
  jest szybki, cięcia są co do klatki i nie zjada pamięci. Wideo kodowane jest raz.
- Wariant „VideoToolbox" jest kilka razy szybszy na Macu, ale odrobinę gorszy jakościowo.
- Filmy o różnych rozmiarach/fps są wyrównane do ustawionej rozdzielczości i fps.
