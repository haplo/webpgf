# WebPGF: WASM library to decode PGF images

TODO

## Build

If you have Docker:

```
./build.sh
```

This will build a Docker image with the necessary dependencies and use it to generate webpgf.js and webpgf.wasm in `dist` directory.

Alternatively you can run `make build` without Docker.
You will need to install the following dependencies:

- emscripten (`emconfigure`, `emmake` and `em++`)
- autoconf
- automake
- libtool

## Developer notes

- `dos2unix` has been applied to libpgf files in this repository, but it's still left as a step in the build process.
