#include <string>
#include <emscripten.h>
#include <emscripten/bind.h>
#include <emscripten/val.h>
#include "PGFimage.h"
#include "PGFstream.h"

using namespace emscripten;

const BYTE BYTES_PER_PIXEL = 4;  // hardcode to RGBA images
int RGBA_CHANNEL_MAP[] = {2, 1, 0, 3};  // hardcode to RGBA channels

thread_local const val Uint8ClampedArray = val::global("Uint8ClampedArray");
thread_local const val ImageData = val::global("ImageData");

// Decode a PGF image into a Javascript ImageData.
//
// Always produce RGBA images (4 bytes per pixel)
val decode(std::string pgf_data) {
  CPGFStream* cpgfstream = new CPGFMemoryStream((UINT8*)pgf_data.c_str(), pgf_data.size());
  CPGFImage* cpgfimage = new CPGFImage();
  cpgfimage->Open(cpgfstream);
  const int level = 0;  // always ready full image for now
  cpgfimage->Read(level);
  UINT32 width = cpgfimage->Width(level);
  UINT32 height = cpgfimage->Height(level);
  size_t output_size = width * height * BYTES_PER_PIXEL;
  UINT8* output = (UINT8*)malloc(output_size);
  int pitch = width * BYTES_PER_PIXEL;
  cpgfimage->GetBitmap(pitch, output, 8 * BYTES_PER_PIXEL, RGBA_CHANNEL_MAP);
  // HACK: GetBitmap consider alpha channel of 0 to be opaque, but in ImageData 0 is
  // interpreted as transparent.
  for (int i = 3; i < output_size; i += 4) {
    output[i] += 0xff;
  }
  val image = ImageData.new_(Uint8ClampedArray.new_(typed_memory_view(output_size, output)),
                             width,
                             height);
  free(output);
  return image;
}

const std::string version() {
  return PGFCodecVersion;
}

EMSCRIPTEN_BINDINGS(webpgf) {
  function("decode", &decode);
  function("version", &version);
}
