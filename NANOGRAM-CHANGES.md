# Nanogram changes

This repository is not a fork of a Git history. It holds the pre-generated SQLCipher amalgamation the Nanogram apps
build, so there is no upstream branch to diff against.

Branch `nanogram` (tag `v4.20.0-nanogram1`):

| What | Source |
| --- | --- |
| `sqlite3.c` and `headers/sqlcipher/{sqlite3.h,sqlite3ext.h,sqlite3session.h}` | SQLCipher 4.20.0 on SQLite 3.54.1, generated from the sqlcipher checkout the Nanogram iOS app uses (`submodules/sqlcipher`), byte for byte; checksums in `SHA256SUMS`, verified by `python3 -I tools/verify.py` |
| `tools/generate-amalgamation.sh`, `tools/verify.py` | Added here: regenerate and verify the amalgamation |
| `README.md` | Compile flags per app (iOS, macOS, Android) |

The amalgamation is never hand-edited; every feature is chosen by the consumer's compile flags. SQLite must stay at
3.51.3 or later (WAL-reset corruption fix).

Android uses this copy with the codec enabled against the BoringSSL it already links. It does not set a key, so
existing plain databases stay plain. Before this it used a separate in-tree SQLite.
