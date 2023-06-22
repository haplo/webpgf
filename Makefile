OPTIMIZATION?=-O3 -g0

.PHONY: clean

build: build_debug build_release

build_debug: dist/webpgf_debug.js
	$(MAKE) $(MAKEOPTS) OPTIMIZATION="-O0 -g3" dist/webpgf_debug.js

build_release: dist/webpgf.js
	$(MAKE) $(MAKEOPTS) OPTIMIZATION="-O3 -g0" dist/webpgf.js

libpgf/configure:
	mkdir -p libpgf/m4
	dos2unix libpgf/*.*
	# libpgf autoreconf expects README to exist
	cp libpgf/README.txt libpgf/README
	cd libpgf && autoreconf -i
	cd libpgf && emconfigure ./configure

libpgf/src/.libs/libpgf.a: libpgf/configure
	cd libpgf && emmake make

dist/webpgf.js dist/webpgf_debug.js : dist libpgf/src/.libs/libpgf.a src/webpgf.cpp
	em++ \
		--bind \
		$(OPTIMIZATION) \
		-s ALLOW_MEMORY_GROWTH=1 \
		-s MODULARIZE=1 \
		-s WASM=1 \
		-s EXPORTED_RUNTIME_METHODS='["cwrap"]' \
		-s EXPORT_NAME="WebPGF" \
		-I libpgf/include/ \
		-o $@ \
		src/webpgf.cpp \
		libpgf/src/.libs/libpgf.a

dist:
	mkdir dist

clean:
	rm -rf \
		dist/* \
		libpgf/configure \
		libpgf/m4 \
		libpgf/**/Makefile{,.in} \
		libpgf/**/*.{a,la,o,lo} \
		libpgf/src/.deps \
		libpgf/src/.libs
