# Legt ein HTML-Starter-Projekt mit vorgefertigter Struktur an.
# Aufruf: .\setup.ps1 mein-projekt

param(
    [string]$Projekt = ""
)

$ErrorActionPreference = "Stop"
$Projekt = if ([string]::IsNullOrWhiteSpace($Projekt)) {
    "website-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
} else {
    $Projekt
}
$Vorlage = Join-Path $PSScriptRoot "template"

if (Test-Path $Projekt) {
    Write-Host "Fehler: '$Projekt' existiert bereits." -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $Vorlage -PathType Container)) {
    Write-Host "Fehler: Vorlage '$Vorlage' wurde nicht gefunden." -ForegroundColor Red
    exit 1
}

New-Item -ItemType Directory -Path $Projekt | Out-Null
Get-ChildItem -LiteralPath $Vorlage -Force |
    Copy-Item -Destination $Projekt -Recurse -Force

Write-Host "Projekt '$Projekt' wurde angelegt:" -ForegroundColor Green
Get-ChildItem -Path $Projekt -Recurse -Force |
    Where-Object { $_.Name -ne ".gitkeep" } |
    ForEach-Object { $_.FullName.Replace((Resolve-Path $Projekt).Path, $Projekt) }