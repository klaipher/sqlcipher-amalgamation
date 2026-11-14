# sqlcipher-amalgamation (Nanogram)

SQLCipher 4.20.0 on SQLite 3.54.1, as a pre-generated amalgamation: `sqlite3.c` plus the public headers in
`headers/sqlcipher/` (`sqlite3.h`, `sqlite3ext.h`, `sqlite3session.h`). One source for Nanogram iOS, macOS and Android.
Branch `nanogram`, tag `v4.20.0-nanogram1`. The files are the iOS copy byte for byte (see `SHA256SUMS`); the amalgamation
is kept pristine, never hand-edited.

Keep SQLite at 3.51.3 or later (WAL-reset corruption fix; the app and the notification extension share one WAL database).

## Regenerating

`tools/generate-amalgamation.sh <sqlcipher checkout>` (needs tclsh). The configure flags do not bake into the output;
every feature is selected by the consumer's `-D` flags. After regenerating, update `SHA256SUMS` and run
`python3 -I tools/verify.py`.

## Compile flags per app

sqlcipher.c `#error`s unless `SQLITE_EXTRA_INIT=sqlcipher_extra_init`, `SQLITE_EXTRA_SHUTDOWN=sqlcipher_extra_shutdown`,
`SQLITE_THREADSAFE` in {1,2}, `SQLITE_TEMP_STORE` in {2,3} and one crypto provider are defined.

Common to all: `SQLITE_HAS_CODEC=1`, the two EXTRA_ hooks, `SQLITE_THREADSAFE=1`, `SQLITE_TEMP_STORE=2`,
`SQLITE_ENABLE_FTS5`, `HAVE_USLEEP=1`, `SQLITE_DEFAULT_MEMSTATUS=0`, `SQLITE_OMIT_LOAD_EXTENSION`, `NDEBUG=1`,
`SQLITE_MAX_MMAP_SIZE=0`, `SQLITE_ENABLE_QPSG`.

- iOS (Bazel `BUILD`): plus `SQLCIPHER_CRYPTO_CC=1` (CommonCrypto), `SQLITE_OMIT_DECLTYPE`, `SQLITE_OMIT_PROGRESS_CALLBACK`,
  `SQLITE_OMIT_DEPRECATED`, `-Wno-ambiguous-macro`, `-Wno-#warnings`. Include path `<sqlcipher/sqlite3.h>`.
- macOS (Package.swift / Xcode, same module as iOS): the same plus `SQLITE_OMIT_SHARED_CACHE`, `SQLITE_MAX_EXPR_DEPTH=0`,
  `SQLITE_LIKE_DOESNT_MATCH_BLOBS`, `SQLITE_USE_ALLOCA`.
- Android (CMake): `SQLCIPHER_CRYPTO_OPENSSL` against the BoringSSL already linked (`crypto`), codec on, never call
  `sqlite3_key`, so database files stay plain SQLite. Do not set `SQLITE_DQS=0` or `SQLITE_OMIT_DEPRECATED` (existing
  Android code relies on legacy behaviour). Header include path must expose `sqlcipher/sqlite3.h` or the Android wrapper
  must switch its include.
