#!/bin/bash

# Get an updated config.sub and config.guess
cp -r ${BUILD_PREFIX}/share/libtool/build-aux/config.* .

# xml2-config add -lz and -llzma to the linker flags, resulting in overlinking
# only libxml2 needs to be linked
export LIBXML_LIBS="-lxml2"
./configure \
    --prefix=$PREFIX \
    --enable-shared \
    --enable-static=no \
    --disable-docs \
    --with-openssl="${PREFIX}" \
    --with-libxml="${PREFIX}" \
    --with-gcrypt="${PREFIX}" \
    --with-xslt="${PREFIX}"

# unit_tests/list_unit_tests.c:826:2: error: no newline at end of file [-Werror,-Wnewline-eof]
printf '\n' >> "$SRC_DIR/apps/unit_tests/list_unit_tests.c"
make -j${CPU_COUNT} ${VERBOSE_AT}
make check
make install
