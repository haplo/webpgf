#include "emscripten.h"
#include "PGFimage.h"

EMSCRIPTEN_KEEPALIVE
const char* version() {
    return PGFCodecVersion;
}
