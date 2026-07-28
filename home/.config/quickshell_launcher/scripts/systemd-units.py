#!/usr/bin/env python3
import subprocess

out = subprocess.run(
    ["systemctl", "list-units", "--all", "--no-pager", "--no-legend", "--plain",
     "--type=service,timer,socket,target"],
    capture_output=True, text=True
).stdout

for line in out.strip().splitlines():
    parts = line.split(None, 4)
    if len(parts) < 4:
        continue
    unit, load, active, sub = parts[0], parts[1], parts[2], parts[3]
    if active == "active":
        dot = "●"
    elif active == "inactive":
        dot = "○"
    else:
        dot = "✕"
    print(f"{dot} {unit} ({sub})")
