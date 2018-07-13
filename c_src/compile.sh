#!/bin/sh

GF_VERSION="a6862d10c9db467148f20eef2c6445ac9afd94d8"
JE_VERSION="de1739cc8483696506829b52e7fda4f6bb195e6a"


if [ ! -d c_src/gf-complete ]; then
    git clone http://lab.jerasure.org/jerasure/gf-complete.git c_src/gf-complete
fi

cd c_src/gf-complete

CURRENT_VERSION=`git rev-parse HEAD`

if [ ! "$GF_VERSION" = "$CURRENT_VERSION" ]; then
    git clean -ddxxff
    git fetch
    git checkout $GF_VERSION
fi

if [ ! -d build ]; then
    mkdir build
    ./autogen.sh
    ./configure --prefix=`pwd`/build --with-pic
fi
make -j
make install

cd ../..

if [ ! -d c_src/jerasure ]; then
    git clone http://lab.jerasure.org/jerasure/jerasure.git c_src/jerasure
fi

cd c_src/jerasure

CURRENT_VERSION=`git rev-parse HEAD`

if [ ! "$JE_VERSION" = "$CURRENT_VERSION" ]; then
    git clean -ddxxff
    git fetch
    git checkout $JE_VERSION
fi

if [ ! -d build ]; then
    mkdir build
    autoreconf --force --install
    LDFLAGS="-L../../gf-complete/build/lib -fPIC" CPPFLAGS="-I../../gf-complete/include" ./configure --prefix=`pwd`/build --enable-static --with-pic
fi
make -j
make install
