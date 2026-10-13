# Wiederverwendbares WordPress-Theme erstellen

Erstelle oder erweitere ein WordPress-Block-Theme für die Agentur. Das Theme wird einmal entwickelt und für mehrere Kunden-Websites wiederverwendet.

## Architekturgrenzen

- Jede Kunden-Website hat eine eigene WordPress-Installation und Datenbank. WordPress verwaltet dort Inhalte und Benutzer; WooCommerce verwaltet Shop, Warenkorb, Checkout und Bestellungen.
- Kundeninhalte, Konten und Zugangsdaten gehören nicht in Theme-Dateien oder dieses Repository. Keine zentrale SaaS-Plattform und kein Theme pro Kunde bauen.
- `site.config.json` ist ein Design-Briefing und eine Quelle für Startwerte, kein Ort für Secrets oder echte Kundenzugangsdaten.
- Theme-Code ist Darstellung. Datenimport, Provisionierung mehrerer Installationen oder Agentur-Mandanten benötigen ein separates Plugin oder einen Dienst und werden nicht ungefragt ergänzt.

## Vorgehen

1. Prüfe Projektstruktur, Briefing, vorhandenes Design, Assets und `references/design/`. Nutze hochgeladene Bilder/PDFs nur als visuelle Orientierung, kopiere ihre Inhalte oder Medien nicht ins Theme. Lege das Theme in `wordpress-theme/` ab. Lies vorhandenen Theme-Code vor Änderungen und überschreibe nichts blind.
2. Frage nach PHP-/WordPress-/WooCommerce-Version oder Architektur nur dann, wenn die Antwort die Umsetzung wesentlich verändert. Sonst ein leichtgewichtiges Block-Theme mit `theme.json`, Templates und Template-Parts verwenden.
3. Erstelle nur benötigte Dateien, typischerweise `style.css`, `theme.json`, `functions.php`, `templates/`, `parts/`, `patterns/` und lokale Assets. Nutze WordPress-Core und den Block-Editor.
4. Berücksichtige Startseite, Seiten, Blog-Archiv, Einzelbeitrag, Suche und 404. Navigation, Header und Footer sollen über WordPress bearbeitbar sein.
5. WooCommerce nur integrieren, wenn gewünscht: Theme-Unterstützung registrieren und Standardblöcke/-templates unterstützen. Keine WooCommerce-Templates überschreiben, wenn Styles oder Hooks reichen. Keine eigene Zahlungs- oder Kontoverwaltung bauen.
6. Überführe Designwerte in `theme.json` und CSS-Variablen. Kundenvarianten sollen über globale Stile und WordPress anpassbar sein, nicht durch Theme-Kopien.
7. Lade CSS und JavaScript über WordPress-Enqueue-Funktionen. Bevorzuge System- oder lokal gehostete Fonts. Google Fonts nur bei ausdrücklicher Auswahl und Bestätigung verwenden und als externen Dienst zur Datenschutzprüfung dokumentieren. Tracking, weitere CDNs und unnötige Plugins vermeiden.
8. Sichere dynamische Ausgabe mit kontextgerechtem WordPress-Escaping. Schreibende Aktionen benötigen Berechtigungsprüfung, Nonce und Sanitization. Keine Secrets speichern.
9. Prüfe PHP-Syntax und verfügbare WordPress-/WooCommerce-Prüfungen. Installiere keine globale Software oder Plugins ungefragt und benenne nicht ausführbare Prüfungen.
10. Fasse Theme-Dateien, Seitentypen, WooCommerce-Status und notwendige Einrichtung pro Kunden-WordPress zusammen.