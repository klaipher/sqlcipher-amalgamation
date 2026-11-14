#!/bin/sh
# Regenerate the SQLCipher amalgamation from a SQLCipher source checkout (a release tarball does not ship it).
# Usage: tools/generate-amalgamation.sh /path/to/sqlcipher-checkout [dest-dir]
# Needs tclsh. Offline-safe: only runs configure/make inside the given checkout.
set -eu
SRC=${1:?path to sqlcipher checkout}
DEST=${2:-$(cd "$(dirname "$0")/.." && pwd)}
cd "$SRC"
./configure --with-tempstore=yes --enable-fts5 \
  CFLAGS="-DSQLITE_HAS_CODEC -DSQLITE_EXTRA_INIT=sqlcipher_extra_init -DSQLITE_EXTRA_SHUTDOWN=sqlcipher_extra_shutdown -DSQLCIPHER_CRYPTO_CC"
make sqlite3.c sqlite3.h   # also copies sqlite3ext.h and ext/session/sqlite3session.h to the root
cp sqlite3.c "$DEST/sqlite3.c"
mkdir -p "$DEST/headers/sqlcipher"
cp sqlite3.h sqlite3ext.h ext/session/sqlite3session.h "$DEST/headers/sqlcipher/"
grep -m1 '#define SQLITE_VERSION ' sqlite3.c
grep -m1 '#define CIPHER_VERSION_NUMBER' sqlite3.c
# configure flags do not bake into the amalgamation: every feature is chosen by the consumer's -D flags (see README).
