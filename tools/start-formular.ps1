$ErrorActionPreference = "Stop"
$BasePort = 8765
$LastPort = 8865
$ServerScript = Join-Path $PSScriptRoot "serve-formular.ps1"
$InstanceBytes = [System.Text.Encoding]::UTF8.GetBytes($PSScriptRoot.ToLowerInvariant())
$InstanceHash = [System.Security.Cryptography.SHA256]::Create().ComputeHash($InstanceBytes)
$InstanceKey = ([System.BitConverter]::ToString($InstanceHash).Replace("-", "").ToLowerInvariant()).Substring(0, 12)

function Get-FormServers {
    $serverProcesses = Get-CimInstance Win32_Process | Where-Object {
        $_.Name -in @("powershell.exe", "pwsh.exe") -and $_.CommandLine -match "serve-formular\.ps1"
    }

    foreach ($process in $serverProcesses) {
        $port = $BasePort
        if ($process.CommandLine -match "-Port\s+(\d+)") {
            $port = [int]$Matches[1]
        }

        $listener = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue |
            Where-Object { $_.OwningProcess -eq $process.ProcessId } |
            Select-Object -First 1
        if (-not $listener) { continue }

        $verified = $false
        $responsive = $false
        try {
            $health = Invoke-WebRequest -Uri "http://127.0.0.1:$port/__health" -UseBasicParsing -TimeoutSec 1
            if ($health.Content.Trim() -eq "HTML-STARTER-FORMULAR:$InstanceKey") {
                $verified = $true
                $responsive = $true
            }
        } catch {
        }

        if (-not $responsive) {
            try {
                $page = Invoke-WebRequest -Uri "http://127.0.0.1:$port/tools/asset-manager.html" -UseBasicParsing -TimeoutSec 1
                if ($page.Content -match '<title>Website-Briefing vorbereiten</title>') {
                    $responsive = $true
                }
            } catch {
            }
        }

        [pscustomobject]@{ ProcessId = $process.ProcessId; Port = $port; Verified = $verified; Responsive = $responsive }
    }
}

function Test-PortAvailable([int]$Port) {
    $probe = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $Port)
    try {
        $probe.Start()
        return $true
    } catch {
        return $false
    } finally {
        $probe.Stop()
    }
}

function Get-FreePort([int]$StartPort) {
    for ($port = $StartPort; $port -le $LastPort; $port++) {
        if (Test-PortAvailable $port) { return $port }
    }
    throw "Kein freier Formular-Port zwischen $StartPort und $LastPort gefunden."
}

function Start-FormServer([int]$Port) {
    $quotedScript = '"' + $ServerScript + '"'
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File $quotedScript -Port $Port -InstanceKey $InstanceKey -NoBrowser"
    $process = Start-Process -FilePath (Join-Path $PSHOME "powershell.exe") -ArgumentList $arguments -WindowStyle Hidden -PassThru
    $ready = $false
    for ($attempt = 0; $attempt -lt 30; $attempt++) {
        try {
            $health = Invoke-WebRequest -Uri "http://127.0.0.1:$Port/__health" -UseBasicParsing -TimeoutSec 1
            if ($health.Content.Trim() -eq "HTML-STARTER-FORMULAR:$InstanceKey") {
                $ready = $true
                break
            }
        } catch {
        }
    }
    if (-not $ready) {
        try { Stop-Process -Id $process.Id -Force -ErrorAction Stop } catch { }
        throw "Formularserver auf Port $Port wurde nicht rechtzeitig bereit."
    }
    Start-Process "http://127.0.0.1:$Port/tools/asset-manager.html"
    Write-Host "Neue Formularinstanz startet auf http://127.0.0.1:$Port/tools/asset-manager.html" -ForegroundColor Green
}

$instances = @(Get-FormServers | Sort-Object Port -Unique)
if ($instances.Count -gt 0) {
    Write-Host "Formularinstanz(en) gefunden:" -ForegroundColor Cyan
    foreach ($instance in $instances) {
        $label = if (-not $instance.Responsive) { "reagiert nicht" } elseif ($instance.Verified) { "verwaltet" } else { "ältere Instanz" }
        Write-Host "  Port $($instance.Port) ($label)"
    }
    Write-Host ""
    Write-Host "1. Vorhandene Instanz oeffnen"
    Write-Host "2. Neue Instanz auf einem freien Port starten"
    Write-Host "3. Alle erkannten Formularinstanzen schliessen"
    Write-Host "0. Abbrechen"
    if ($instances.Where({ -not $_.Responsive }).Count -gt 0) {
        Write-Host "Hinweis: Nicht antwortende Instanzen lassen sich nicht oeffnen; schliesse sie oder starte eine neue." -ForegroundColor Yellow
    }
    $choice = Read-Host "Auswahl"

    switch ($choice) {
        "1" {
            $port = $instances[0].Port
            Start-Process "http://127.0.0.1:$port/tools/asset-manager.html"
            Write-Host "Vorhandene Instanz auf Port $port geoeffnet." -ForegroundColor Green
        }
        "2" {
            $port = Get-FreePort ($BasePort + 1)
            Start-FormServer $port
        }
        "3" {
            foreach ($instance in $instances) {
                try { Stop-Process -Id $instance.ProcessId -Force -ErrorAction Stop } catch { }
            }
            Write-Host "Alle erkannten Formularinstanzen wurden beendet. Fremde Programme wurden nicht beendet." -ForegroundColor Green
        }
        "0" { Write-Host "Abgebrochen." }
        default { Write-Host "Ungueltige Auswahl; es wurde nichts geaendert." -ForegroundColor Yellow }
    }
} else {
    $port = Get-FreePort $BasePort
    if ($port -ne $BasePort) {
        Write-Host "Port $BasePort ist anderweitig belegt; verwende Port $port." -ForegroundColor Yellow
    }
    Start-FormServer $port
}