param(
    [int]$Port = 8765,
    [string]$InstanceKey = "",
    [switch]$NoBrowser
)

$ErrorActionPreference = "Stop"
$InstanceKey = if ([string]::IsNullOrWhiteSpace($InstanceKey)) {
    $RootBytes = [System.Text.Encoding]::UTF8.GetBytes($PSScriptRoot.ToLowerInvariant())
    $HashBytes = [System.Security.Cryptography.SHA256]::Create().ComputeHash($RootBytes)
    ([System.BitConverter]::ToString($HashBytes).Replace("-", "").ToLowerInvariant()).Substring(0, 12)
} else {
    $InstanceKey
}
$PagePath = Join-Path $PSScriptRoot "asset-manager.html"
$Address = "http://127.0.0.1:$Port/tools/asset-manager.html"
$StopToken = [guid]::NewGuid().ToString("N")
$Listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $Port)

try {
    $Listener.Start()
    Write-Host "Bildformular laeuft lokal unter $Address" -ForegroundColor Green
    Write-Host "Dieses Fenster offen lassen. Mit Strg+C wird der Server beendet." -ForegroundColor DarkGray
    if (-not $NoBrowser) {
        Start-Process $Address
    }

    while ($true) {
        $Client = $Listener.AcceptTcpClient()
        $ShouldStop = $false
        try {
            $Stream = $Client.GetStream()
            $Stream.ReadTimeout = 5000
            $Reader = [System.IO.StreamReader]::new($Stream, [System.Text.Encoding]::ASCII, $false, 1024, $true)
            $RequestLine = $Reader.ReadLine()
            $StopTokenHeader = ""
            $OriginHeader = ""
            while ($true) {
                $HeaderLine = $Reader.ReadLine()
                if ([string]::IsNullOrEmpty($HeaderLine)) { break }
                if ($HeaderLine -match '^X-Form-Server-Token:\s*(.+)$') { $StopTokenHeader = $Matches[1].Trim() }
                if ($HeaderLine -match '^Origin:\s*(.+)$') { $OriginHeader = $Matches[1].Trim() }
            }

            $IsHealthRequest = $RequestLine -match '^GET /__health(?:\?.*)? HTTP/1\.[01]$'
            $IsPageRequest = $RequestLine -match '^GET (?:/|/tools/asset-manager\.html)(?:\?.*)? HTTP/1\.[01]$'
            $IsStopRequest = $RequestLine -match '^POST /__shutdown HTTP/1\.[01]$'
            $ParsedOrigin = $null
            try { $ParsedOrigin = [uri]$OriginHeader } catch { }
            $OriginAllowed = $null -ne $ParsedOrigin -and $ParsedOrigin.IsLoopback -and $ParsedOrigin.Scheme -eq "http" -and $ParsedOrigin.Port -eq $Port

            if ($IsHealthRequest) {
                $StatusLine = "HTTP/1.1 200 OK"
                $ContentType = "text/plain; charset=utf-8"
                $Body = [System.Text.Encoding]::UTF8.GetBytes("HTML-STARTER-FORMULAR:$InstanceKey")
                $Csp = "default-src 'none'; frame-ancestors 'none'"
            } elseif ($IsPageRequest) {
                $StatusLine = "HTTP/1.1 200 OK"
                $ContentType = "text/html; charset=utf-8"
                $PageContent = [System.IO.File]::ReadAllText($PagePath, [System.Text.Encoding]::UTF8).Replace("__FORM_SERVER_STOP_TOKEN__", $StopToken)
                $Body = [System.Text.Encoding]::UTF8.GetBytes($PageContent)
                $Csp = "default-src 'none'; script-src 'unsafe-inline'; style-src 'unsafe-inline'; img-src 'self' blob: data:; connect-src 'self'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'"
            } elseif ($IsStopRequest -and $OriginAllowed -and [string]::Equals($StopTokenHeader, $StopToken, [System.StringComparison]::Ordinal)) {
                $StatusLine = "HTTP/1.1 200 OK"
                $ContentType = "text/plain; charset=utf-8"
                $Body = [System.Text.Encoding]::UTF8.GetBytes("Form server stopping")
                $Csp = "default-src 'none'; frame-ancestors 'none'"
                $ShouldStop = $true
            } elseif ($IsStopRequest) {
                $StatusLine = "HTTP/1.1 403 Forbidden"
                $ContentType = "text/plain; charset=utf-8"
                $Body = [System.Text.Encoding]::UTF8.GetBytes("Forbidden")
                $Csp = "default-src 'none'; frame-ancestors 'none'"
            } else {
                $StatusLine = "HTTP/1.1 404 Not Found"
                $ContentType = "text/plain; charset=utf-8"
                $Body = [System.Text.Encoding]::UTF8.GetBytes("Not found")
                $Csp = "default-src 'none'; frame-ancestors 'none'"
            }

            $Headers = "$StatusLine`r`nContent-Type: $ContentType`r`nContent-Length: $($Body.Length)`r`nCache-Control: no-store`r`nX-Content-Type-Options: nosniff`r`nContent-Security-Policy: $Csp`r`nConnection: close`r`n`r`n"
            $HeaderBytes = [System.Text.Encoding]::ASCII.GetBytes($Headers)
            $Stream.Write($HeaderBytes, 0, $HeaderBytes.Length)
            $Stream.Write($Body, 0, $Body.Length)
            $Stream.Flush()
            $Reader.Dispose()
        } catch [System.IO.IOException] {
            # A browser can cancel a request while the response is being written.
        } finally {
            $Client.Dispose()
        }
        if ($ShouldStop) { break }
    }
} finally {
    $Listener.Stop()
}