# SEO- und Qualitätsprüfung

Prüfe auslieferbare Seiten im Projekt-Root. Components und Vorlagen sind keine eigenständigen Seiten. Ändere keine Dateien.

Prüfe je Seite:

- genau eine `<h1>` und nachvollziehbare Überschriftenhierarchie
- einzigartiger `<title>`, Meta-Description und Canonical
- passende Open-Graph-Metadaten und valides JSON-LD mit sichtbaren Fakten
- Bilder mit passendem Alt-Text sowie `width` und `height`
- funktionierende interne Links; Header und Footer entsprechen den Components
- FAQPage-Daten stimmen mit sichtbaren FAQs überein
- `sitemap.xml`, `robots.txt` und `llms.txt` passen zu den vorhandenen Seiten
- unerklärte TODOs, erfundene Inhalte, fehlende Skip-Links oder Fokuszustände

Berichte zuerst kritische Fehler, danach Warnungen und Hinweise. Nenne Datei, Fundstelle und konkrete Korrektur. Bestätige, wenn alles geprüft ist, und führe manuelle Restprüfungen separat auf.