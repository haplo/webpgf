#include "emscripten.h"
#include "PGFimage.h"

EMSCRIPTEN_KEEPALIVE
extern "C" const char* version() {
    return PGFCodecVersion;
}
