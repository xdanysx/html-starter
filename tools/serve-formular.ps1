$ErrorActionPreference = "Stop"
$Port = 8765
$PagePath = Join-Path $PSScriptRoot "asset-manager.html"
$Address = "http://127.0.0.1:$Port/tools/asset-manager.html"
$Listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Loopback, $Port)

try {
    $Listener.Start()
    Write-Host "Bildformular läuft lokal unter $Address" -ForegroundColor Green
    Write-Host "Dieses Fenster offen lassen. Mit Strg+C wird der Server beendet." -ForegroundColor DarkGray
    Start-Process $Address

    while ($true) {
        $Client = $Listener.AcceptTcpClient()
        try {
            $Stream = $Client.GetStream()
            $Reader = [System.IO.StreamReader]::new($Stream, [System.Text.Encoding]::ASCII, $false, 1024, $true)
            $RequestLine = $Reader.ReadLine()
            while ($null -ne ($HeaderLine = $Reader.ReadLine()) -and $HeaderLine -ne "") { }

            $IsPageRequest = $RequestLine -match '^GET (?:/|/tools/asset-manager\.html)(?:\?.*)? HTTP/1\.[01]$'
            if ($IsPageRequest) {
                $StatusLine = "HTTP/1.1 200 OK"
                $ContentType = "text/html; charset=utf-8"
                $Body = [System.IO.File]::ReadAllBytes($PagePath)
                $Csp = "default-src 'none'; script-src 'unsafe-inline'; style-src 'unsafe-inline'; img-src 'self' blob: data:; connect-src 'self'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'"
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
        } finally {
            $Client.Dispose()
        }
    }
} finally {
    $Listener.Stop()
}