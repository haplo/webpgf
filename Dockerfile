FROM emscripten/emsdk:3.1.41

RUN echo "## Installing extra dependencies" \
    && apt-get -qq -y update \
    && apt-get -qq install -y --no-install-recommends \
        autoconf \
        automake \
        dos2unix \
        libtool \
    && echo "## Done"

COPY libpgf /src

RUN mkdir -p m4 \
    && dos2unix *.* \
    && cp README.txt README \
    && emconfigure autoreconf -i \
    && emconfigure ./configure \
    && emmake make -j
