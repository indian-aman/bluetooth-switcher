---
name: bluetooth-switcher
description: Seamlessly toggle between internal Intel Bluetooth and external Realtek USB Bluetooth adapter on Windows, clearing PnP Code 31 adapter conflicts and handling attached device overrides. Use when the user needs to switch Bluetooth adapters, fix Bluetooth audio/dongle connection issues, or toggle between built-in and external Bluetooth.
---

# Bluetooth Switcher Skill (Windows)

Automated utility for switching between the built-in Intel Bluetooth radio and an external Realtek USB Bluetooth dongle on Windows 11.

## Problem Solved
Windows does not cleanly support two active Bluetooth controller radios at once. When a USB Bluetooth dongle is plugged into a laptop with an internal Intel Bluetooth controller, device conflict errors (such as **Code 31**) or routing priority issues occur. This skill cleanly forces disablement of the inactive adapter and restarts the active one via `pnputil` and PnP PowerShell APIs.

## Commands

- **Switch to USB Dongle:**
  ```powershell
  & "C:\Users\BARODA\.gemini\antigravity\scratch\bluetooth-switcher\Switch-to-USB-Bluetooth.bat"
  ```
- **Restore Built-in Bluetooth:**
  ```powershell
  & "C:\Users\BARODA\.gemini\antigravity\scratch\bluetooth-switcher\Restore-Builtin-Bluetooth.bat"
  ```
