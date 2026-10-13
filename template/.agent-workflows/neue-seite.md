# Einzelne Seite erstellen

Erstelle die vom Nutzer benannte Seite nach `CLAUDE.md`, falls vorhanden, und `site.config.json`.

1. Lies das Briefing, vorhandene Seiten, `css/style.css`, `js/main.js` und die passenden Components.
2. Wenn wichtige Angaben für die Seite fehlen oder `TODO` enthalten, frage gesammelt nach und ändere noch keine Dateien. Erfinde keine Fakten.
3. Erzeuge einen kurzen URL-Slug in Kleinbuchstaben, mit Bindestrichen und ohne Umlaute. Die Startseite ist `index.html`, andere Seiten liegen als `<slug>.html` im Projekt-Root.
4. Erstelle eine vollständige, eigenständige HTML-Seite mit genau einer `<h1>`. Übernimm Header und Footer aus den Components; passe Navigation in Components und betroffenen Seiten synchron an.
5. Nutze CSS-Variablen und vorhandene Muster. Ergänze eindeutigen Seitentitel, Description, Canonical, Open-Graph-Daten und passende strukturierte Daten. FAQ-Text und FAQPage-Daten müssen übereinstimmen.
6. Ergänze passende interne Links und aktualisiere `sitemap.xml` sowie `llms.txt`. Prüfe Bilder, Alt-Texte, Maße, Links und Überschriftenhierarchie. Fasse Änderungen kurz zusammen.