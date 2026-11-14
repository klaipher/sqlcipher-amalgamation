#!/usr/bin/env python3
"""Pure check: version markers and checksums. Run: python3 -I tools/verify.py"""
import hashlib, pathlib, re, sys
root = pathlib.Path(__file__).resolve().parent.parent
c = (root / "sqlite3.c").read_text(errors="replace")
sv = re.search(r'#define SQLITE_VERSION\s+"([^"]+)"', c).group(1)
cv = re.search(r'#define CIPHER_VERSION_NUMBER\s+(\S+)', c).group(1)
print("SQLite", sv, "SQLCipher", cv)
assert sv == "3.54.1" and cv == "4.20.0", "unexpected version"
for line in (root / "SHA256SUMS").read_text().splitlines():
    h, p = line.split(None, 1)
    got = hashlib.sha256((root / p.strip()).read_bytes()).hexdigest()
    assert got == h, f"checksum mismatch {p}"
print("ok")
