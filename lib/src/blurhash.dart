part of base83;

/// Encoder class for the blur hash.
class Blurhash {
  /// Decode a given Base83 string into a Uint8List representing the image.
  static Uint8List? decode(
    String blurHash,
    int width,
    int height, {
    double punch = 1.0,
  }) {
    if (blurHash.length < 6) {
      return null;
    }
    int numCompEnc = base83Decode(blurHash.substring(0, 1));
    int numCompX = (numCompEnc % 9) + 1;
    int numCompY = ((numCompEnc / 9) + 1).floor();
    if (blurHash.length != 4 + 2 * numCompX * numCompY) {
      return null;
    }
    int maxAcEnc = base83Decode(blurHash.substring(1, 2));
    double maxAc = (maxAcEnc + 1) / 166.0;

    final colors = <_Color>[];
    final colorCount = numCompX * numCompY;
    for (int i = 0; i < colorCount; i++) {
      if (i == 0) {
        int colorEnc = base83Decode(blurHash.substring(2, 6));
        colors.add(_decodeDc(colorEnc));
      } else {
        int from = 4 + i * 2;
        int colorEnc = base83Decode(blurHash.substring(from, from + 2));
        colors.add(_decodeAc(colorEnc, maxAc * punch));
      }
    }

    final bitmap = _createBitmapData(width, height, numCompX, numCompY, colors);

    return _createBitmapImage(bitmap, width, height);
  }

  static _Color _decodeDc(final int colorEnc) {
    final int r = colorEnc >> 16;
    final int g = (colorEnc >> 8) & 255;
    final int b = colorEnc & 255;
    return _Color(
      _srgbToLinear(r),
      _srgbToLinear(g),
      _srgbToLinear(b),
    );
  }

  static double _srgbToLinear(final int colorEnc) {
    final double v = colorEnc / 255.0;

    if (v <= 0.04045) {
      return (v / 12.92);
    } else {
      return pow((v + 0.055) / 1.055, 2.4).toDouble();
    }
  }

  static _Color _decodeAc(int value, double maxAc) {
    double r = value / (19 * 19).floor();
    double g = (value / 19) % 19.floor();
    int b = value % 19;
    return _Color(
      _signedPow2((r - 9) / 9.0) * maxAc,
      _signedPow2((g - 9) / 9.0) * maxAc,
      _signedPow2((b - 9) / 9.0) * maxAc,
    );
  }

  static int _linearToSrgb(double value) {
    double v;
    if (value > 1) {
      v = 1.0;
    } else if (value < 0) {
      v = 0.0;
    } else {
      v = value;
    }
    if (v <= 0.0031308) {
      return (v * 12.92 * 255 + 0.5).round();
    } else {
      return ((1.055 * pow(v, 1 / 2.4) - 0.055) * 255 + 0.5).round();
    }
  }

  static double _signedPow2(double value) {
    return value.sign * value * value;
  }

  static Uint8List _createBitmapData(
      int width, int height, int numCompX, int numCompY, List<_Color> colors) {
    Int32List list = Int32List(width * height);
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        double r = 0.0;
        double g = 0.0;
        double b = 0.0;
        for (int j = 0; j < numCompY; j++) {
          for (int i = 0; i < numCompX; i++) {
            double basis =
                (cos(pi * x * i / width) * cos(pi * y * j / height)).toDouble();
            final color = colors[j * numCompX + i];
            r += color.r * basis;
            g += color.g * basis;
            b += color.b * basis;
          }
        }
        int index = y * width + x;
        final color =
            _fromRGB(_linearToSrgb(b), _linearToSrgb(g), _linearToSrgb(r));
        list[index] = color;
      }
    }
    return list.buffer.asUint8List();
  }
}

const int _bmpHeaderSize = 122;
Uint8List _createBitmapImage(Uint8List content, int width, int height) {
  final fileLength = content.length + _bmpHeaderSize;
  final bmp = Uint8List(fileLength);

  bmp.buffer.asByteData()
    ..setUint8(0x0, 0x42)
    ..setUint8(0x1, 0x4d)
    ..setInt32(0x2, fileLength, Endian.little)
    ..setInt32(0xa, _bmpHeaderSize, Endian.little)
    ..setUint32(0xe, 108, Endian.little)
    ..setUint32(0x12, width, Endian.little)
    ..setUint32(0x16, -height, Endian.little)
    ..setUint16(0x1a, 1, Endian.little)
    ..setUint32(0x1c, 32, Endian.little)
    ..setUint32(0x1e, 3, Endian.little)
    ..setUint32(0x22, content.length, Endian.little)
    ..setUint32(0x36, 0x000000ff, Endian.little)
    ..setUint32(0x3a, 0x0000ff00, Endian.little)
    ..setUint32(0x3e, 0x00ff0000, Endian.little)
    ..setUint32(0x42, 0xff000000, Endian.little);

  bmp.setRange(
    _bmpHeaderSize,
    content.length + _bmpHeaderSize,
    content,
  );

  return bmp;
}

int _fromRGB(int r, int g, int b) =>
    (((0xff) << 24) |
        ((r & 0xff) << 16) |
        ((g & 0xff) << 8) |
        ((b & 0xff) << 0)) &
    0xFFFFFFFF;

class _Color {
  _Color(this.r, this.g, this.b);

  double r;
  double g;
  double b;
}
