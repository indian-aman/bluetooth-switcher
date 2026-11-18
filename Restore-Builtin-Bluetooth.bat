@echo off
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting Administrator privileges via Windows UAC...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0use-builtin-bluetooth.ps1"
echo.
echo Done! Your built-in Intel Wireless Bluetooth should now be active again.
pause
