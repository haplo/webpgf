EMCC_OPTS=\
  --bind \
  -s ALLOW_MEMORY_GROWTH=1 \
  -s MODULARIZE=1 \
  -s WASM=1 \
  -s EXPORTED_RUNTIME_METHODS='["cwrap"]' \
  -s EXPORT_NAME="WebPGF" \
  -I libpgf/include/ \
  -o $@ \
  src/webpgf.cpp \
  libpgf/src/.libs/libpgf.a

.PHONY: build clean

build: dist/webpgf.js dist/webpgf_debug.js

dist/webpgf.js : libpgf/src/.libs/libpgf.a src/webpgf.cpp
	em++ -O3 -g0 $(EMCC_OPTS)

dist/webpgf_debug.js : libpgf/src/.libs/libpgf.a src/webpgf.cpp
	em++ -O0 -g3 $(EMCC_OPTS)

libpgf/configure:
	mkdir -p libpgf/m4
	dos2unix libpgf/*.*
	# libpgf autoreconf expects README to exist
	cp libpgf/README.txt libpgf/README
	cd libpgf && autoreconf -i
	cd libpgf && emconfigure ./configure

libpgf/src/.libs/libpgf.a: libpgf/configure
	cd libpgf && emmake make

clean:
	git clean -f -d libpgf/
	rm -f dist/*
