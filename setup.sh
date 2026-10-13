#!/usr/bin/env bash
# Legt ein HTML-Starter-Projekt mit vorgefertigter Struktur an.
# Aufruf: ./setup.sh mein-projekt

set -e

PROJEKT="${1:-website-$(date +%Y%m%d-%H%M%S)}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VORLAGE="$SCRIPT_DIR/template"

if [ -e "$PROJEKT" ]; then
  echo "Fehler: '$PROJEKT' existiert bereits."
  exit 1
fi

if [ ! -d "$VORLAGE" ]; then
  echo "Fehler: Vorlage '$VORLAGE' wurde nicht gefunden."
  exit 1
fi

mkdir -p "$PROJEKT"
cp -R "$VORLAGE"/. "$PROJEKT"/

echo "Projekt '$PROJEKT' wurde angelegt:"
find "$PROJEKT" ! -name ".gitkeep" | sort