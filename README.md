# HTML Starter

Dieses Repository ist ein Generator. Die eigentliche Website entsteht erst in einem neu erzeugten Ordner.

## Website anlegen

- Unter Windows `neue-website.bat` doppelklicken oder `setup.ps1 mein-projekt` ausführen.
- Unter macOS im Terminal `bash ./setup.sh mein-projekt` ausführen. Die Bash-Variante funktioniert auch unter Linux.
- Ohne Namen wird ein Ordner `website-JJJJMMTT-hhmmss` angelegt.
- Den erzeugten Website-Ordner anschließend separat in VS Code öffnen.

## Ordner

- `template/` ist die Vorlage, die Setup-Skripte vollständig in jedes neue Projekt kopieren. Änderungen an der Vorlage gelten für künftige Projekte.
- `tools/` enthält das lokale Formular zum Bearbeiten von `site.config.json` und zum Hinzufügen von Bildern. `formular-starten.bat` öffnet eine vorhandene Instanz, startet bei Bedarf eine weitere auf einem freien Port oder schließt erkannte Formularserver. Im Formular zeigt der Status die Serververfügbarkeit und den Speicherstand; „Server beenden“ stoppt die lokale Instanz nach Bestätigung.
- `.claude/`, `.github/` und `.agent-workflows/` innerhalb `template/` sind die Assistenten-Einstiege und gemeinsamen Arbeitsanweisungen, die in neue Projekte mitkopiert werden.
- `setup.ps1`, `setup.sh` und `neue-website.bat` sind nur Generator-Hilfen; sie gehören nicht in die veröffentlichte Website.

## Website mit einem Assistenten erstellen

1. Den erzeugten Website-Ordner in VS Code öffnen.
2. `tools/formular-starten.bat` aus diesem Generator-Ordner starten und im Formular den Website-Ordner auswählen.
3. Briefing und Bilder speichern.
4. Im Copilot-Chat den Prompt `/website-erstellen` oder in Claude Code den Befehl `/website-erstellen` ausführen.

Die gemeinsamen Abläufe liegen pro Website einmal in `.agent-workflows/`. Die gleichnamigen Copilot-Prompts und Claude-Commands starten diese Abläufe.