# Website erstellen

Erzeuge eine statische Website nach `CLAUDE.md`, falls vorhanden, und `site.config.json`.

1. Lies das Briefing, vorhandene Seiten und Components sowie verfügbare Assets. Nutze nur belegte Fakten. Wenn für aktive Seiten wichtige Angaben fehlen oder `TODO` enthalten, stelle eine gebündelte Rückfrage und ändere vorher keine Projektdateien. Leere optionale Listen sind erlaubt.
2. Erstelle nur Seiten, die im Seitenplan `include: true` haben. Schreibe statisches, semantisches HTML, ein gemeinsames `css/style.css` und nur notwendige Interaktionen in `js/main.js`. Inhalte und Navigation dürfen nicht erst per JavaScript geladen werden.
3. Verwende `design.visualDirection`, Farbwerte und lokale Schriften aus `site.config.json`. Definiere Designwerte als CSS-Variablen und nutze vorhandene Components.
4. Übernimm Header und Footer aus den Components und gleiche alle Links mit dem Seitenplan ab. Bilder müssen aus `assets/` stammen; verwende konfigurierte Alt-Texte, Maße, Fokuspunkt und Quelle. Hero-Bilder im sichtbaren Bereich nicht lazy laden.
5. Ergänze je Seite eindeutige SEO-Metadaten, Canonical, Open Graph und passende strukturierte Daten. Aktualisiere `sitemap.xml`, `robots.txt` und `llms.txt` anhand der erstellten Seiten.
6. Erstelle Impressum und Datenschutz nur als Entwürfe, soweit erforderlich. Erfinde keine rechtlichen Angaben und kennzeichne ungeklärte Punkte klar zur Betreiber- bzw. Rechtsprüfung.
7. Prüfe Links, Überschriften, Metadaten, JSON-LD, Assets und verbleibende TODOs. Veröffentliche keine Briefings, Agentenanweisungen oder `.git/`-Daten. Fasse geänderte Dateien und offene Prüfungen zusammen.