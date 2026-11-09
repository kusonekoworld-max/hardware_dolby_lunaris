#!/usr/bin/env python3
# Baca log avc dari stdin, keluarin allow rule KHUSUS Dolby. Rule berbahaya di-comment (REVIEW).
import re, sys
from collections import defaultdict

RE = re.compile(r'avc:\s+denied\s+\{([^}]+)\}.*?scontext=u:r:(\w+):s0\S*\s+tcontext=u:\w+:(\w+):s0\S*\s+tclass=(\w+)')
KEY = re.compile(r'dolby|dms|dax|dap|lunaris|motorola', re.I)
DMS_T = {'hal_dms_default', 'hal_dms_default_exec', 'hal_dms_hwservice'}
BAD_CLASS = {'capability', 'capability2', 'tcp_socket', 'udp_socket', 'rawip_socket',
             'netlink_socket', 'netlink_route_socket', 'packet_socket', 'bpf'}
BAD_PERM = {'sys_admin', 'dac_override', 'dac_read_search', 'sys_ptrace', 'sys_module',
            'setuid', 'setgid', 'mounton', 'relabelfrom', 'relabelto', 'execmem', 'execmod'}
BAD_TGT = {'device', 'unlabeled', 'debugfs', 'shell_data_file', 'zygote', 'init', 'kernel',
           'system_file', 'system_data_file', 'vendor_file', 'vendor_configs_file', 'su', 'adbd'}

ok, review = defaultdict(set), defaultdict(set)
for line in sys.stdin:
    m = RE.search(line)
    if not m:
        continue
    perms, src, tgt, cls = m.group(1).split(), m.group(2), m.group(3), m.group(4)
    if not (src == 'hal_dms_default' or tgt in DMS_T or KEY.search(line)):
        continue
    bad = cls in BAD_CLASS or tgt in BAD_TGT or any(p in BAD_PERM for p in perms)
    # tulis ke file/dir sistem selalu REVIEW; baca/getattr/open ke tipe lain boleh
    if tgt in BAD_TGT and not (set(perms) <= {'read', 'open', 'getattr', 'map', 'search'} and tgt in {'vendor_file', 'vendor_configs_file'}):
        bad = True
    (review if bad else ok)[(src, tgt, cls)].update(perms)

def emit(d, prefix=''):
    for (s, t, c), p in sorted(d.items()):
        print(f"{prefix}allow {s} {t}:{c} {{ {' '.join(sorted(p))} }};")

print('# === dolby_extra.te: hasil log, cek satu-satu sebelum dipakai ===')
emit(ok)
if review:
    print('\n# === REVIEW: terlalu luas / berbahaya, JANGAN langsung dipakai ===')
    emit(review, '#')
