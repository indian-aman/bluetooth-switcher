#!/usr/bin/env python3
import os
import zipfile

here = os.path.dirname(os.path.abspath(__file__))
dist_dir = os.path.join(here, "dist")
os.makedirs(dist_dir, exist_ok=True)

skill_pkg = os.path.join(dist_dir, "bluetooth-switcher.skill")
zip_pkg = os.path.join(dist_dir, "bluetooth-switcher.zip")

with zipfile.ZipFile(skill_pkg, "w", zipfile.ZIP_DEFLATED) as zf:
    for f in os.listdir(here):
        if f in ("dist", "__pycache__") or f.endswith((".skill", ".zip", ".pyc")):
            continue
        zf.write(os.path.join(here, f), os.path.join("bluetooth-switcher", f))

with zipfile.ZipFile(zip_pkg, "w", zipfile.ZIP_DEFLATED) as zf:
    for f in os.listdir(here):
        if f in ("dist", "__pycache__") or f.endswith((".skill", ".zip", ".pyc")):
            continue
        zf.write(os.path.join(here, f), os.path.join("bluetooth-switcher", f))

print(f"[OK] Built bluetooth-switcher packages:")
print(f"  - {skill_pkg}")
print(f"  - {zip_pkg}")
