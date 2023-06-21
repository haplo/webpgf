FROM emscripten/emsdk:3.1.41 AS libpgf-build

RUN echo "## Installing extra dependencies" \
    && apt-get -qq -y update \
    && apt-get -qq install -y --no-install-recommends \
        autoconf \
        automake \
        dos2unix \
        libtool \
    # Standard Cleanup on Debian images
    && apt-get -y clean \
    && apt-get -y autoclean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/debconf/*-old \
    && rm -rf /usr/share/doc/* \
    && rm -rf /usr/share/man/?? \
    && rm -rf /usr/share/man/??_* \
    && echo "## Done"

# COPY libpgf /src

# RUN mkdir -p m4 \
#     && dos2unix *.* \
#     && cp README.txt README \
#     && emconfigure autoreconf -i \
#     && emconfigure ./configure \
#     && emmake make -j

# FROM emscripten/emsdk:3.1.41 AS webpgf-build

# COPY src /src

# # copy emscripten-compiled libpgf library
# COPY --from=libpgf-build /src/src/.libs/libpgf.a /src

# # copy patched libpgf headers
# COPY --from=libpgf-build /src/include /src/include
