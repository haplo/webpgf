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

class PGFImage {
protected:
  CPGFImage* cpgfimage;
  CPGFStream* cpgfstream;

public:
  PGFImage(std::string pgf_data) {
    cpgfstream = new CPGFMemoryStream((UINT8*)pgf_data.c_str(), pgf_data.size());
    cpgfimage = new CPGFImage();
    cpgfimage->Open(cpgfstream);
  }

  ~PGFImage() {
    delete cpgfimage;
    delete cpgfstream;
  }

  // Decode the PGF image into a Javascript ImageData.
  //
  // Always produce 4 bits-per-pixel images (RGBA format).
  //
  // level is a PGF format concept, 0 being the original size,
  // call levels() to get the maximum level available for this image
  val decode(int level) const {
    cpgfimage->Read(level);
    UINT32 width = cpgfimage->Width(level);
    UINT32 height = cpgfimage->Height(level);
    size_t output_size = width * height * BYTES_PER_PIXEL;
    UINT8* output = (UINT8*)malloc(output_size);
    int pitch = width * BYTES_PER_PIXEL;
    cpgfimage->GetBitmap(pitch, output, BYTES_PER_PIXEL, RGBA_CHANNEL_MAP);
    return ImageData.new_(Uint8ClampedArray.new_(typed_memory_view(output_size, output)),
                          width,
                          height);
  }

  BYTE levels() {
    return cpgfimage->Levels();
  }
};

const std::string version() {
  return PGFCodecVersion;
}

EMSCRIPTEN_BINDINGS(webpgf) {
  function("version", &version);
  class_<PGFImage>("PGFImage")
    .constructor<std::string>()
    .function("decode", &PGFImage::decode)
    .function("levels", &PGFImage::levels)
    // .function("Open", &CPGFImage::Open)
    // .function("Read", &CPGFImage::Read)
    // .function("GetBitmap", &PGFImage::GetBitmap)
    // .function("Level", &CPGFImage::Level)
    // .function("Levels", &CPGFImage::Levels)
    ;
  // class_<CPGFMemoryStream>("CPGFMemoryStream")
  //     .constructor<[ref] Uint8Array, long>()
  //     ;
}
