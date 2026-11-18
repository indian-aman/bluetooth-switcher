$ErrorActionPreference = 'Continue'
$logFile = Join-Path $PSScriptRoot 'last_switch.log'

function Write-Log($text) {
    $clean = ($text | Out-String) -replace "`0", ""
    Write-Host $clean.TrimEnd()
    Add-Content -Path $logFile -Value $clean.TrimEnd() -Encoding utf8
}

"=== Restoring Built-in Intel Bluetooth ($(Get-Date -Format o)) ===" | Set-Content -Path $logFile -Encoding utf8

Write-Log "1. Disabling USB Realtek Bluetooth Adapter..."
$out1 = & pnputil.exe /disable-device /deviceid "USB\VID_0BDA&PID_C820&MI_00" /class Bluetooth /force 2>&1
Write-Log $out1

Start-Sleep -Seconds 2

Write-Log "2. Enabling built-in Intel(R) Wireless Bluetooth(R)..."
$out2 = & pnputil.exe /enable-device /deviceid "USB\VID_8087&PID_0AAA" /class Bluetooth 2>&1
Write-Log $out2

Start-Sleep -Seconds 2

Write-Log "--- Final Adapter State ---"
$table = Get-PnpDevice -Class Bluetooth | Where-Object { $_.InstanceId -like 'USB\*' } |
    Select-Object Status, Problem, FriendlyName, InstanceId |
    Format-Table -AutoSize | Out-String
Write-Log $table
