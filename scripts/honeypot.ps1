<#
    Educational SQL Server port honeypot for a controlled lab environment.

    Назначение:
    - слушать TCP 1433 в тестовой среде после переноса реального SQL Server
      на внутренний нестандартный порт;
    - фиксировать попытки подключения для учебного анализа.

    This is not production IDS tooling. It does not replace firewall rules,
    SIEM, endpoint monitoring, or network segmentation.
#>

[CmdletBinding()]
param(
    [int]$Port = 1433,
    [string]$LogDirectory = $(if ($env:AIS_HONEYPOT_LOG_DIR) {
        $env:AIS_HONEYPOT_LOG_DIR
    } else {
        Join-Path $env:ProgramData 'ais-attendance\honeypot'
    })
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $LogDirectory)) {
    New-Item -ItemType Directory -Path $LogDirectory -Force | Out-Null
}

$logPath = Join-Path $LogDirectory ("sql1433-honeypot-{0:yyyyMMdd}.log" -f (Get-Date))
$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any, $Port)

function Write-HoneypotLog {
    param(
        [string]$RemoteEndpoint,
        [string]$PayloadPreview
    )

    $entry = [ordered]@{
        timestamp_utc = (Get-Date).ToUniversalTime().ToString('o')
        host = $env:COMPUTERNAME
        port = $Port
        remote_endpoint = $RemoteEndpoint
        payload_preview = $PayloadPreview
    }

    ($entry | ConvertTo-Json -Compress) | Add-Content -LiteralPath $logPath -Encoding UTF8
}

try {
    $listener.Start()
    Write-Host "Educational honeypot listening on TCP port $Port. Logs: $logPath"

    while ($true) {
        $client = $listener.AcceptTcpClient()
        $remoteEndpoint = $client.Client.RemoteEndPoint.ToString()
        $payloadPreview = ''

        try {
            $stream = $client.GetStream()
            $buffer = New-Object byte[] 64

            if ($stream.DataAvailable) {
                $bytesRead = $stream.Read($buffer, 0, $buffer.Length)
                if ($bytesRead -gt 0) {
                    $payloadPreview = [System.BitConverter]::ToString($buffer, 0, $bytesRead)
                }
            }

            Write-HoneypotLog -RemoteEndpoint $remoteEndpoint -PayloadPreview $payloadPreview
        } finally {
            $client.Close()
        }
    }
} finally {
    $listener.Stop()
}
