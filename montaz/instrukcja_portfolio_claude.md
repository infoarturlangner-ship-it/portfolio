# Instrukcja dla Claude: graficzny opis programu do montażu (sekcja portfolio)

Skopiuj całość poniżej do nowej rozmowy z Claude. Jeśli masz zrzuty ekranu programu, dołącz je do wiadomości. Jeśli nie, Claude zrobi stylizowane makiety interfejsu.

---

## Zadanie

Stwórz **graficzną stronę (jeden samodzielny plik HTML)**, która w portfolio przedstawia możliwości mojego autorskiego programu do montażu wideo. Ma to być efektowna, nowoczesna prezentacja z grafikami i diagramami, a nie suchy tekst. Strona ma wyglądać świetnie na **komputerze (desktop)** i **telefonie (mobile)**.

Odbiorcy: osoby przeglądające moje portfolio (potencjalni klienci, pracodawcy, współpracownicy). Mają w kilkadziesiąt sekund zrozumieć: co to za narzędzie, jaki problem rozwiązuje i że potrafię zbudować złożone narzędzie od pomysłu do działającego rezultatu.

Język strony: **polski** (nagłówki krótkie i konkretne). Jeśli to proste, dodaj przełącznik PL/EN.

## O programie (fakty, trzymaj się ich)

**Co to jest.** Osobiste narzędzie w jednym pliku HTML (czysty JavaScript, bez serwera, bez wysyłania plików do chmury). Działa w przeglądarce, a właściwy montaż robi wygenerowany skrypt `bash` z `ffmpeg`, uruchamiany lokalnie (macOS, działa też na Linuksie). Zbudowane do montażu kilkugodzinnych nagrań z gry (Fortnite, tryb kooperacyjny, komentarz po polsku) w gotowe odcinki, momenty, skróty i shorty.

**Główna idea.** Dwa nagrania tej samej rozgrywki (dwie kamery/perspektywy) są synchronizowane znacznikami. Program przełącza kamery, gdy w transkrypcji padnie wybrane słowo kluczowe, i generuje gotowy montaż.

**Możliwości (pogrupuj je w czytelne sekcje/zakładki):**

1. **Synchronizacja i podgląd**
   - wczytanie dwóch filmów i transkrypcji (SRT/VTT/JSON), znaczniki M1/M2 do zsynchronizowania kamer,
   - podgląd montażu w przeglądarce z osią czasu i trafieniami słów.
2. **Montaż na słowa kluczowe**
   - wiele słów z akcjami (przełącz kamerę, kamera 1, kamera 2, „z tej transkrypcji”), tolerancja trafień,
   - automatyczna zmiana kamery co N sekund,
   - osobny dźwięk cięcia: domyślny i własny dla każdego słowa,
   - efekt przy cięciu: błysk oraz wideo z kanałem alfa.
3. **Grafiki i nakładki**
   - nakładki graficzne (PNG) przeciągane myszą w podglądzie,
   - nakładki wideo z kanałem alfa uruchamiane słowem kluczowym (np. „subskrybuj”), kilka naraz.
4. **Zajawka „W dzisiejszym odcinku”**
   - zajawki na początku odcinka, podział na części z tytułami i osobną transkrypcją każdej części,
   - wybór fragmentów zajawki przez ChatGPT (program generuje instrukcję i wczytuje odpowiedź JSON).
5. **Najlepsze momenty (osobny film)**
   - wybór momentów przez ChatGPT (śmieszne/ciekawe), tytuły z animacjami (wjazd, pop, odsłanianie, odbicie), własne czcionki,
   - muzyka z automatycznym przyciszaniem (ducking), wersja dłuższa i krótsza.
6. **„W tym tygodniu” (skrót z lektorem)**
   - skrót tygodnia z narracją lektora (np. ElevenLabs): program wykrywa przerwy w nagraniu i dopasowuje długość każdej sceny do jej akapitu,
   - dźwięk z gry ściszany pod lektorem, muzyka, intro z alfą i zapętlona nakładka.
7. **Shorty pionowe 9:16**
   - film 16:9 pośrodku pionowego kadru, własna nakładka (PNG albo zapętlone wideo z alfą), krótkie wstawki lektora w trakcie rozmowy i puenta,
   - podgląd shorta w programie, outro z łagodnym wejściem dźwięku, render pojedynczych plików na każdy short.
8. **Eksport**
   - skrypt `render.sh`: kontrola brakujących plików, wznawianie po przerwie, sprawdzanie każdego fragmentu, podział na części, intro/outro z płynnym przenikaniem dźwięku, zapis i wczytanie projektu, eksport EDL do DaVinci.

**Cechy techniczne (do sekcji „Pod maską”):** jeden plik HTML z czystym JS, Web Audio API (wykrywanie przerw w lektorze, podgląd), generowanie skryptów `ffmpeg` (filter_complex, sidechain ducking, nakładki alfa, pętle), testowane na prawdziwym ffmpeg i w automatycznych testach przeglądarki.

**Czego NIE twierdzić:** to osobiste narzędzie, nie produkt SaaS. Nie podawaj wymyślonych liczb (użytkownicy, oszczędność czasu, oceny). Wybór fragmentów robi zewnętrznie ChatGPT, a program tylko generuje instrukcję i wczytuje jego odpowiedź; nie pisz, że program „sam używa AI”. Nie wstawiaj logo ani nazw firm.

## Wymagana zawartość strony

1. **Hero:** nazwa programu („Montaż na słowo”), jedno zdanie o wartości, krótki podtytuł i wizualizacja (np. dwie ścieżki wideo splatające się w jeden montaż, animowana oś czasu).
2. **Diagram przepływu (pipeline):** 2 nagrania + transkrypcja → synchronizacja → słowa kluczowe → montaż → skrypt ffmpeg → gotowy mp4. Czytelny na desktopie (poziomo) i na telefonie (pionowo).
3. **Karty możliwości** (8 grup z listy wyżej): każda z ikoną, krótkim opisem i małą grafiką/makietą (np. oś czasu z cięciami, pionowy kadr 9:16 z ramką, falowa kreska lektora z przyciszaniem dźwięku).
4. **Sekcja „Zakładki programu”:** stylizowana makieta interfejsu z poziomymi zakładkami (Pliki, Podgląd, Słowa i cięcia, Grafiki i efekty, Zajawka, Najlepsze momenty, W tym tygodniu, Shorty, Eksport). Jeśli dołączę zrzuty ekranu, użyj ich w ramce przeglądarki.
5. **Wyróżnik: shorty 9:16** w osobnej, wizualnej sekcji (kadr, nakładka, lektor, outro).
6. **„Pod maską”:** krótkie punkty techniczne i stos (HTML/JS, Web Audio, ffmpeg, bash) jako chipy.
7. **Stopka z miejscem na link** do repozytorium lub kontaktu (placeholder, który mogę podmienić).

## Wymagania wizualne i techniczne

- **Styl:** ciemny, nowoczesny, spójny z programem. Paleta: tło `#14161a`, panele `#1d2027`, linie `#2d323c`, tekst `#e6e8ec`, tekst pomocniczy `#8b93a1`, akcenty: niebieski `#4c8dff` (kamera 1), pomarańczowy `#ff9a3c` (kamera 2), zielony `#3ecf8e`. Zdefiniuj kolory jako zmienne CSS (`:root`) i przygotuj też jasny wariant z `prefers-color-scheme`.
- **Grafiki:** wyłącznie inline SVG i CSS (bez zewnętrznych obrazków), ostre na każdym ekranie. Diagramy i makiety mają być zrobione w SVG/CSS, nie jako płaskie bloki tekstu.
- **Desktop:** układ do ok. 1200 px szerokości, siatki 2–4 kolumny, duże, czytelne sekcje.
- **Mobile:** układ jednokolumnowy, marginesy boczne 16 px, brak poziomego przewijania strony, przyciski i elementy dotykowe min. 44 px, tekst min. 16 px. Diagram przepływu zmienia się z poziomego na pionowy, makiety skalują się bez ucinania.
- **Animacje:** subtelne (pojawianie przy przewijaniu, delikatny ruch osi czasu), z respektowaniem `prefers-reduced-motion`.
- **Dostępność:** kontrast zgodny z WCAG AA, sensowna hierarchia nagłówków, `alt`/`aria-label` dla grafik.
- **Wydajność:** jeden plik, bez bibliotek, jeśli to możliwe. Gdyby biblioteka była potrzebna, tylko z cdnjs w konkretnej wersji.
- **Nie wymyślaj** treści spoza podanych faktów. Jeśli czegoś brakuje (np. link, zrzuty ekranu), zostaw wyraźny, łatwy do podmiany placeholder.

## Sposób pracy

1. Najpierw w 5–8 punktach pokaż mi krótko plan struktury strony i pomysł na kluczowe grafiki, i dopiero potem zbuduj.
2. Po zbudowaniu sprawdź stronę w szerokościach ok. 390 px i ok. 1280 px (brak ucięć, brak poziomego przewijania) i napisz mi, co sprawdziłeś.
3. Na końcu wypisz, co mam podmienić (link, zrzuty ekranu, dane kontaktowe).
