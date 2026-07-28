#!/usr/bin/env python3
import os, glob, time, signal
signal.signal(signal.SIGPIPE, signal.SIG_DFL)

d = os.path.expanduser("~/Pictures/screenshots")
if not os.path.isdir(d):
    exit()

cutoff = time.time() - 30 * 86400
files = []
for ext in ("*.jpg", "*.png", "*.webp"):
    files.extend(glob.glob(os.path.join(d, ext)))

files = [(os.path.getmtime(f), f) for f in files if os.path.getmtime(f) > cutoff]
files.sort(reverse=True)

for mtime, path in files:
    t = time.localtime(mtime)
    label = time.strftime("%d/%m/%Y %H:%M", t)
    print(f"{label} | {path}")
