#!/usr/bin/env python3
"""
install_skill.py — Installs bluetooth-switcher into local AI coding agents:
  - Antigravity (~/.gemini/config/skills/bluetooth-switcher)
  - Claude Code (~/.claude/skills/bluetooth-switcher)
  - OpenAI Codex (~/.codex/skills/bluetooth-switcher)
"""

import os
import shutil
import sys

here = os.path.dirname(os.path.abspath(__file__))
home = os.path.expanduser("~")
targets = [
    os.path.join(home, ".gemini", "config", "skills", "bluetooth-switcher"),
    os.path.join(home, ".claude", "skills", "bluetooth-switcher"),
    os.path.join(home, ".codex", "skills", "bluetooth-switcher"),
]

for dst in targets:
    os.makedirs(dst, exist_ok=True)
    for f in os.listdir(here):
        if f in ("dist", "__pycache__"):
            continue
        src_path = os.path.join(here, f)
        dst_path = os.path.join(dst, f)
        if os.path.isfile(src_path):
            shutil.copy2(src_path, dst_path)
    print(f"[+] Installed bluetooth-switcher -> {dst}")

print("[OK] bluetooth-switcher skill installed successfully.")
