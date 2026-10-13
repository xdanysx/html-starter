# CLAUDE.md – HTML-Projekt

Diese Datei wird von Claude Code automatisch gelesen. Alle Regeln hier gelten für jede Seite, die du erzeugst oder änderst.

## 1. Projekt-Briefing

`site.config.json` ist die zentrale Quelle für projektspezifische Fakten, Kontaktdaten, Seiten und Assets. Vor der Erstellung oder Änderung von Inhalten vollständig lesen. Fehlende oder als `TODO` markierte Angaben gesammelt beim Betreiber erfragen; niemals Fakten, rechtliche Angaben oder Bildbeschreibungen erfinden.

Die JSON-Datei ist nur Briefing für Claude und wird nicht im Browser geladen. Inhalte werden direkt in das statische HTML geschrieben. `js/main.js` ist ausschließlich für notwendige Interaktionen gedacht, nicht als Datenbank oder Quelle für Seiteninhalte.

## 2. Technischer Rahmen

- Reines HTML, CSS und Vanilla-JavaScript. Kein Framework, kein Build-Schritt, kein npm.
- Keine externen Abhängigkeiten (keine CDNs, keine Google Fonts, keine Tracking-Skripte). Schriften lokal in `assets/fonts/` als `.woff2`.
- Semantisches HTML5, valide, UTF-8.
- Mobile-first, responsive ohne Frameworks (CSS Grid, Flexbox, `clamp()`).
- Pfade sind root-relativ (`/css/style.css`). Lokal immer über einen Server testen (z. B. VS Code Live Server oder `npx serve`), nicht per Doppelklick auf die Datei.
- `CLAUDE.md`, `site.config.json`, `.claude/` und `.git/` sind Entwicklungsdateien und dürfen nicht im öffentlichen Webroot landen. Beim Deployment nur öffentliche Seiten, `css/`, `js/`, `assets/`, `robots.txt`, `sitemap.xml` und `llms.txt` veröffentlichen.

## 3. Ordnerstruktur

```
/
├── CLAUDE.md
├── site.config.json        ← zentrale Projektdaten und Asset-Zuordnung
├── index.html
├── <seite>.html            ← weitere Seiten im Root, Dateiname = URL-Slug
├── components/             ← Vorlagen für wiederkehrende Bausteine
│   ├── header.html
│   ├── footer.html
│   ├── faq.html
│   └── card.html
├── assets/
│   ├── img/                ← Bilder (WebP/AVIF bevorzugt, SVG für Icons)
│   └── fonts/              ← .woff2
├── css/style.css           ← einzige Stylesheet-Datei, Design-Tokens oben
├── js/main.js              ← einzige JS-Datei, am Ende mit defer
├── robots.txt
├── sitemap.xml
├── llms.txt
├── .agent-workflows/       ← gemeinsame Arbeitsanweisungen für Claude und Copilot
├── .github/prompts/        ← Prompts für GitHub Copilot Chat
└── .claude/commands/       ← Slash-Commands
```

Regeln:
- Dateinamen: Kleinbuchstaben, Bindestriche, keine Umlaute (`ueber-uns.html`).
- Neue Dateien nur in dieser Struktur anlegen. Keine zusätzlichen CSS-/JS-Dateien ohne Rückfrage.
- Dateien in `components/` sind Vorlagen und werden nie direkt im Browser ausgeliefert oder in der Sitemap geführt.

## 4. Design

- Alle Farben, Abstände, Schriftgrößen und Radien kommen als **CSS-Variablen** aus dem `:root`-Block in `css/style.css`. Keine hartkodierten Werte in Komponenten.
- Look & Feel: reduziert, viel Weißraum, klare Typografie-Hierarchie, ein Akzentfarbton.
- Schrift: maximal 2 Schriftfamilien, `font-display: swap`.
- Kontrast mindestens WCAG AA (4,5:1 für Text).
- Dark Mode via `prefers-color-scheme`, sofern im Briefing nicht anders festgelegt.
- Animationen sparsam, immer `prefers-reduced-motion` respektieren.
- Klassennamen: BEM-ähnlich (`.card`, `.card__title`, `.card--featured`).

## 5. Seitenaufbau

Jede Seite folgt diesem Gerüst:

1. Header aus `components/header.html` (Skip-Link, Logo, Navigation)
2. `<main id="main">` mit genau **einer** `<h1>`
3. Inhalt in `<section class="section">`-Blöcken, jede mit eigener `<h2>`, Inhalt in `.container`
4. FAQ-Block aus `components/faq.html` auf allen inhaltlichen Seiten
5. CTA-Bereich
6. Footer aus `components/footer.html`

Pflicht im `<head>` jeder Seite:

```html
<!DOCTYPE html>
<html lang="de">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Seitentitel | Marke</title>              <!-- max. ca. 60 Zeichen -->
  <meta name="description" content="…">           <!-- 120–160 Zeichen, mit Nutzenversprechen -->
  <link rel="canonical" href="https://example.de/seite">
  <meta name="robots" content="index, follow">

  <meta property="og:type" content="website">
  <meta property="og:title" content="…">
  <meta property="og:description" content="…">
  <meta property="og:url" content="https://example.de/seite">
  <meta property="og:image" content="https://example.de/assets/img/og.jpg">
  <meta name="twitter:card" content="summary_large_image">

  <link rel="icon" href="/assets/img/favicon.svg" type="image/svg+xml">
  <link rel="preload" href="/assets/fonts/….woff2" as="font" type="font/woff2" crossorigin>
  <link rel="stylesheet" href="/css/style.css">
  <script type="application/ld+json">…</script>
  <script src="/js/main.js" defer></script>
</head>
```

## 6. SEO-Regeln

- Genau eine `<h1>` pro Seite, Hauptkeyword natürlich enthalten. Überschriften nie überspringen (h1 → h2 → h3).
- Jede Seite hat einen einzigartigen `<title>`, eine einzigartige Meta-Description und eine Canonical-URL.
- Interne Links mit aussagekräftigem Linktext (nie "hier klicken").
- Alle Bilder: `alt`-Text (beschreibend, bei dekorativen Bildern `alt=""`), `width` und `height` gesetzt, `loading="lazy"` außer bei Bildern im sichtbaren Bereich.
- Bildformate: WebP/AVIF, Dateinamen sprechend (`team-buero-essen.webp`).
- URLs kurz, sprechend, ohne Umlaute und Sonderzeichen.
- Core Web Vitals: kein Layout Shift (feste Bildgrößen), kritisches CSS schlank halten, JS nur mit `defer`.
- Bei jeder neuen Seite: Eintrag in `sitemap.xml` mit `<lastmod>` ergänzen.
- `robots.txt` verweist auf die Sitemap.

### Strukturierte Daten (JSON-LD)

- Startseite: `Organization` oder `LocalBusiness` (mit Name, URL, Logo, Adresse, Kontakt, `sameAs`) plus `WebSite`.
- Unterseiten: `WebPage` bzw. passender Typ (`Service`, `Product`, `Article`, `AboutPage`, `ContactPage`).
- Alle Seiten mit Brotkrumen: `BreadcrumbList`.
- Seiten mit FAQ-Block: `FAQPage` (Inhalt muss exakt dem sichtbaren FAQ entsprechen).
- Artikel: `Article` mit `author`, `datePublished`, `dateModified`.
- Nur Daten auszeichnen, die auf der Seite tatsächlich sichtbar sind.

## 7. GEO-Regeln (Optimierung für KI-Suche und Antwortmaschinen)

Ziel: Inhalte so aufbauen, dass KI-Systeme sie korrekt verstehen, zitieren und empfehlen.

- **Antwort zuerst:** Jede Sektion beginnt mit 1–2 Sätzen, die die Kernfrage direkt und eigenständig beantworten. Details folgen danach.
- **Fragen als Überschriften:** Wo sinnvoll, `<h2>`/`<h3>` als echte Nutzerfrage formulieren ("Was kostet …?", "Wie läuft … ab?").
- **Eigenständige Absätze:** Jeder Absatz muss ohne Kontext verständlich sein (Marke/Thema beim Namen nennen, keine Verweise wie "wie oben erwähnt").
- **Konkrete Fakten:** Zahlen, Preise, Zeiträume, Orte, Namen, Zertifikate. Keine Floskeln, keine leeren Superlative.
- **FAQ-Block** auf jeder inhaltlichen Seite: 4–8 echte Fragen mit kurzen, präzisen Antworten (40–80 Wörter), passend zum `FAQPage`-Schema.
- **Listen und Tabellen** für Vergleiche, Schritte und Eigenschaften (leicht extrahierbar).
- **Entität klar benennen:** Wer ist die Marke, was bietet sie, wo, für wen? Auf Startseite und "Über uns" in einem klaren Definitionssatz.
- **Vertrauenssignale:** Autor und Veröffentlichungs-/Aktualisierungsdatum bei Artikeln, Kontaktdaten, Impressum, Quellenangaben bei Fakten.
- **Konsistenz:** Name, Adresse, Telefon (NAP) überall identisch.
- **`llms.txt`** im Root pflegen: kurze Projektbeschreibung und eine Liste der wichtigsten Seiten mit je einer Zeile Beschreibung. Bei neuen Seiten ergänzen.
- **`robots.txt`:** Reguläre Crawler und gängige KI-Crawler (z. B. GPTBot, ClaudeBot, PerplexityBot, Google-Extended) nur dann sperren, wenn das Briefing es verlangt. Standard: erlauben.
- Wichtige Inhalte immer als echtes HTML im Quelltext, nie nur per JavaScript nachgeladen.

## 8. Barrierefreiheit

- Skip-Link zum `<main>` als erstes Element im `<body>` (steckt in `components/header.html`).
- Sichtbarer Fokus-Stil für alle interaktiven Elemente.
- Navigation per Tastatur vollständig bedienbar.
- Formularfelder mit `<label>`, Buttons als `<button>`, Links als `<a>`.
- ARIA nur, wo natives HTML nicht reicht.

## 9. Inhalte und Text

- Sprache und Tonalität laut Briefing. Kurze Sätze, aktive Sprache.
- Keine erfundenen Fakten, Zitate, Bewertungen, Kundennamen oder Zahlen. Unbekanntes als `TODO:` markieren und nachfragen.
- Platzhalterbilder klar kennzeichnen (`TODO: Bild ersetzen`).
- Rechtliches (Impressum, Datenschutz) nur als Gerüst anlegen und auf Prüfung durch den Betreiber hinweisen.

## 10. Arbeitsweise

- Vor größeren Änderungen kurz sagen, welche Dateien betroffen sind.
- Bestehende Dateien vollständig lesen, bevor sie geändert werden.
- Header und Footer immer aus `components/` übernehmen, nie aus dem Gedächtnis neu schreiben.
- Nach jeder neuen oder geänderten Seite prüfen:
  1. Eine `<h1>`, saubere Hierarchie
  2. Title, Description, Canonical gesetzt
  3. JSON-LD valide
  4. Alt-Texte vorhanden
  5. `sitemap.xml` und `llms.txt` aktualisiert
  6. Interne Links funktionieren
  7. Header und Footer entsprechen den Vorlagen in `components/`
- Kurz zusammenfassen, was erstellt oder geändert wurde.

## 11. Verfügbare Commands

- `/website-erstellen` – erstellt die Website nach `.agent-workflows/website-erstellen.md`
- `/neue-seite <Name>` – erzeugt eine Seite nach `.agent-workflows/neue-seite.md`
- `/seo-check` – prüft nach `.agent-workflows/seo-check.md`
- `/wordpress-theme-erstellen` – erstellt ein wiederverwendbares Theme nach `.agent-workflows/wordpress-theme-erstellen.md`

Die gleichnamigen Copilot-Prompts in `.github/prompts/` verweisen auf dieselben Arbeitsanweisungen. Fachliche Änderungen an Abläufen nur in `.agent-workflows/` pflegen; Command- und Prompt-Dateien sind Startpunkte.

## 12. Components

Reines HTML kennt keine Includes. Deshalb gilt `components/` als **Single Source of Truth** für wiederkehrende Bausteine. Die Bausteine werden direkt in jede Seite kopiert (kein Nachladen per JavaScript, damit Crawler den Inhalt im Quelltext sehen).

- **`header.html`** und **`footer.html`** stehen auf jeder Seite identisch. Einzige erlaubte Abweichung: `aria-current="page"` beim Navigationslink der aktuellen Seite.
- **`faq.html`** wird auf inhaltlichen Seiten eingefügt. Platzhalter ersetzen, Anzahl der Fragen anpassen, JSON-LD synchron halten.
- **`card.html`** ist das Muster für Karten innerhalb eines `.grid`-Containers.
- Wird die Navigation geändert (neue Seite, Umbenennung): zuerst `components/header.html` und `components/footer.html` anpassen, dann den Header-/Footer-Block in **allen** bestehenden Seiten ersetzen.
- Neue wiederkehrende Bausteine (mindestens 2 Verwendungen) als neue Datei in `components/` anlegen und hier in Abschnitt 3 ergänzen.
- Alle `TODO:`-Platzhalter in Components müssen beim Einfügen ersetzt werden. Eine fertige Seite enthält kein `TODO:` mehr.