# WebPGF: WASM library to decode PGF images

## Build

If you have Docker:

```
./build.sh
```

This will build a Docker image with the necessary dependencies and use it to generate webpgf.js and webpgf.wasm in `dist` directory.

By default the generated Javascript and WASM files are optimized.
Use `build.sh --debug` to generate files suitable for debugging.

Alternatively you can run `make build` without Docker.
You will need to install the following dependencies:

- emscripten (`emconfigure`, `emmake` and `em++`)
- autoconf
- automake
- libtool

## Developer notes

- `dos2unix` has been applied to libpgf files in this repository, but it's still left as a step in the build process.
