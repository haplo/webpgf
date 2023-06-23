# WebPGF

WebPGF is a WASM port of the [libPGF](https://libpgf.org/) library with a focus on decoding PGF images in the browser.
Encoding of PGF images is not supported and is not planned.

## Build

Install [Docker](https://docs.docker.com/get-docker/) and *make*, then run:

```
./build.sh
```

This will build a Docker image with the necessary dependencies and use it to generate release and debug versions of *webpgf.js* and *webpgf.wasm* in `dist` directory.

Run `make clean` to delete generated files.

Alternatively you can run `make build` without Docker.
You will need to install the following dependencies:

- *make*
- *emscripten* (`emconfigure`, `emmake` and `em++`)
- *autoconf*
- *automake*
- *libtool*

## Developer notes

- libpgf needs to be patched to support emscripten. See commit 191f03ed5c2ec02 for the details.
- `dos2unix` has been applied to libpgf files in this repository, but it's still left as a step in the build process.

## License

WebPGF is distributed under the LGPLv3 license, see [LICENSE](LICENSE) for details.

libPGF is distributed under its own license, see [libpgf/LICENSE](libpgf/LICENSE).
