$ErrorActionPreference = 'Continue'
$logFile = Join-Path $PSScriptRoot 'last_switch.log'

function Write-Log($text) {
    $clean = ($text | Out-String) -replace "`0", ""
    Write-Host $clean.TrimEnd()
    Add-Content -Path $logFile -Value $clean.TrimEnd() -Encoding utf8
}

"=== Switching to USB Bluetooth ($(Get-Date -Format o)) ===" | Set-Content -Path $logFile -Encoding utf8

Write-Log "1. Disabling built-in Intel(R) Wireless Bluetooth(R) (using /force because a Bluetooth mouse 'Toad 8' is attached)..."
$out1 = & pnputil.exe /disable-device /deviceid "USB\VID_8087&PID_0AAA" /class Bluetooth /force 2>&1
Write-Log $out1

Start-Sleep -Seconds 2

$intelBt = Get-PnpDevice -Class Bluetooth | Where-Object { $_.InstanceId -like 'USB\VID_8087&PID_0AAA\*' -and $_.Present }
if ($intelBt -and $intelBt.Status -eq 'OK') {
    Write-Log "Fallback: Disabling Intel(R) Wireless Bluetooth(R) via Disable-PnpDevice..."
    $intelBt | Disable-PnpDevice -Confirm:$false -ErrorAction Continue
    Start-Sleep -Seconds 2
}

Write-Log "2. Resetting USB Realtek Bluetooth Adapter to clear Code 31..."
$out2 = & pnputil.exe /disable-device /deviceid "USB\VID_0BDA&PID_C820&MI_00" /class Bluetooth /force 2>&1
Write-Log $out2
Start-Sleep -Seconds 2
$out3 = & pnputil.exe /enable-device /deviceid "USB\VID_0BDA&PID_C820&MI_00" /class Bluetooth 2>&1
Write-Log $out3

Start-Sleep -Seconds 3

$usbBt = Get-PnpDevice -Class Bluetooth | Where-Object { $_.InstanceId -like 'USB\VID_0BDA&PID_C820&MI_00\*' -and $_.Present }
if ($usbBt -and $usbBt.Status -ne 'OK') {
    Write-Log "3. Restarting USB Realtek Bluetooth Adapter..."
    $out4 = & pnputil.exe /restart-device /deviceid "USB\VID_0BDA&PID_C820&MI_00" /class Bluetooth 2>&1
    Write-Log $out4
    Start-Sleep -Seconds 3
    $usbBt = Get-PnpDevice -Class Bluetooth | Where-Object { $_.InstanceId -like 'USB\VID_0BDA&PID_C820&MI_00\*' -and $_.Present }
}

Write-Log "--- Final Adapter State ---"
$table = Get-PnpDevice -Class Bluetooth | Where-Object { $_.InstanceId -like 'USB\*' } |
    Select-Object Status, Problem, FriendlyName, InstanceId |
    Format-Table -AutoSize | Out-String
Write-Log $table

if ($usbBt -and $usbBt.Status -eq 'OK') {
    Write-Host "[SUCCESS] Realtek USB Bluetooth Adapter is now your ACTIVE main Bluetooth!" -ForegroundColor Green
    Add-Content -Path $logFile -Value "[SUCCESS] Realtek USB Bluetooth Adapter is OK." -Encoding utf8
    exit 0
} else {
    Write-Host "[FAILED] Realtek USB Bluetooth Adapter is still not OK. Check last_switch.log." -ForegroundColor Red
    Add-Content -Path $logFile -Value "[FAILED] Realtek USB Bluetooth Adapter did not reach OK." -Encoding utf8
    exit 1
}
