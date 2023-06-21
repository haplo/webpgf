build: dist/webpgf.js

libpgf/configure:
	mkdir -p libpgf/m4
	dos2unix libpgf/*.*
	# libpgf autoreconf expects README to exist
	cp libpgf/README.txt libpgf/README
	cd libpgf && autoreconf -i
	cd libpgf && emconfigure ./configure

libpgf/src/.libs/libpgf.a: libpgf/configure
	cd libpgf && emmake make

dist/webpgf.js: libpgf/src/.libs/libpgf.a
	em++ \
		--bind \
		-s ALLOW_MEMORY_GROWTH=1 \
		-s MODULARIZE=1 \
		-s 'EXPORT_NAME="webpgf"' \
		-I libpgf/include/ \
		-o $@ \
		src/webpgf.cpp \
		libpgf/src/.libs/libpgf.a

clean:
	rm -rf \
		dist/* \
		libpgf/configure \
		libpgf/m4 \
		libpgf/**/Makefile \
		libpgf/**/*.{a,la,o,lo}
