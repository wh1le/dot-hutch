#!/usr/bin/env python3
import os, signal
signal.signal(signal.SIGPIPE, signal.SIG_DFL)

uid = os.getuid()
procs = []
clk = os.sysconf("SC_CLK_TCK")
with open("/proc/uptime") as f:
    uptime = float(f.read().split()[0])

for pid in os.listdir("/proc"):
    if not pid.isdigit():
        continue
    try:
        if os.stat(f"/proc/{pid}").st_uid != uid:
            continue
        with open(f"/proc/{pid}/stat") as f:
            raw = f.read()
            # comm is between first ( and last )
            i = raw.index("(") + 1
            j = raw.rindex(")")
            fields = raw[j+2:].split()
            utime = int(fields[11])
            stime = int(fields[12])
            starttime = int(fields[19])
        age = uptime - starttime / clk
        cpu = ((utime + stime) / clk / age * 100) if age > 0 else 0
        with open(f"/proc/{pid}/statm") as f:
            rss = int(f.read().split()[1]) * 4096 // 1024 // 1024
        with open(f"/proc/{pid}/cmdline", "rb") as f:
            cmd = f.read().replace(b"\x00", b" ").decode(errors="replace").strip()
        if not cmd:
            continue
        # Use basename of first arg as name
        name = os.path.basename(cmd.split()[0])
        procs.append((cpu + rss * 0.1, int(pid), name, cpu, rss))
    except (FileNotFoundError, PermissionError, ValueError, IndexError):
        continue

procs.sort(reverse=True)
for _, pid, name, cpu, rss in procs[:100]:
    print(f"{pid} {name} ({cpu:.1f}% {rss}MB)")
