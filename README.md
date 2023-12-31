# WebPGF

WebPGF is a WASM port of the [libPGF](https://libpgf.org/) library with a focus on decoding PGF images in the browser.
Encoding of PGF images neither supported nor planned.

PGF codec is used for the thumbnails in the [Digikam](https://www.digikam.org/) photo software.

## Demo

Included is a [simple HTML file](src/index.html) that loads the WebPGF library and allows decoding and displaying PGF files.

Due to web browser limitations, you cannot just open the demo file using the `file://` protocol, it needs to be served by a web server through HTTP protocol.
A simple solution is to use Python to start a web server:

```
# in webpgf root directory
python3 -m http.server
```

Then open [http://localhost:8000/src/](http://localhost:8000/src/) and the demo should work.
You can use the images from [pgf-images](pgf-images) folder.

## Build

Ready-to-use builds are included in the [dist](dist) directory.

To build, install [Docker](https://docs.docker.com/get-docker/) and [make](https://www.gnu.org/software/make/), then run:

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

## Bugs and contact

See [https://github.com/haplo/webpgf/issues](https://github.com/haplo/webpgf/issues) for open issues, and open a new one if you find a new bug.

## License

WebPGF is distributed under the LGPLv3 license, see [LICENSE](LICENSE) for details.

libPGF is distributed under its own license, see [libpgf/COPYING](libpgf/COPYING).
