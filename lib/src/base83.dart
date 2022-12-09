part of base83;

const List<int> _alphabet = [
  48,
  49,
  50,
  51,
  52,
  53,
  54,
  55,
  56,
  57,
  65,
  66,
  67,
  68,
  69,
  70,
  71,
  72,
  73,
  74,
  75,
  76,
  77,
  78,
  79,
  80,
  81,
  82,
  83,
  84,
  85,
  86,
  87,
  88,
  89,
  90,
  97,
  98,
  99,
  100,
  101,
  102,
  103,
  104,
  105,
  106,
  107,
  108,
  109,
  110,
  111,
  112,
  113,
  114,
  115,
  116,
  117,
  118,
  119,
  120,
  121,
  122,
  35,
  36,
  37,
  42,
  43,
  44,
  45,
  46,
  58,
  59,
  61,
  63,
  64,
  91,
  93,
  94,
  95,
  123,
  124,
  125,
  126,
];

const _reverse = {
  48: 0,
  49: 1,
  50: 2,
  51: 3,
  52: 4,
  53: 5,
  54: 6,
  55: 7,
  56: 8,
  57: 9,
  65: 10,
  66: 11,
  67: 12,
  68: 13,
  69: 14,
  70: 15,
  71: 16,
  72: 17,
  73: 18,
  74: 19,
  75: 20,
  76: 21,
  77: 22,
  78: 23,
  79: 24,
  80: 25,
  81: 26,
  82: 27,
  83: 28,
  84: 29,
  85: 30,
  86: 31,
  87: 32,
  88: 33,
  89: 34,
  90: 35,
  97: 36,
  98: 37,
  99: 38,
  100: 39,
  101: 40,
  102: 41,
  103: 42,
  104: 43,
  105: 44,
  106: 45,
  107: 46,
  108: 47,
  109: 48,
  110: 49,
  111: 50,
  112: 51,
  113: 52,
  114: 53,
  115: 54,
  116: 55,
  117: 56,
  118: 57,
  119: 58,
  120: 59,
  121: 60,
  122: 61,
  35: 62,
  36: 63,
  37: 64,
  42: 65,
  43: 66,
  44: 67,
  45: 68,
  46: 69,
  58: 70,
  59: 71,
  61: 72,
  63: 73,
  64: 74,
  91: 75,
  93: 76,
  94: 77,
  95: 78,
  123: 79,
  124: 80,
  125: 81,
  126: 82
};

/// Encodes a number into its Base83-representation
class Base83Encoder extends Converter<int, String> {
  /// The constructor.
  const Base83Encoder(this.length);

  /// Expected output length.
  final int length;

  @override
  String convert(int input) {
    List<int> output = [];
    for (var i = 0; i < length; i++) {
      var digit = input % 83;
      input ~/= 83;

      output.insert(0, _alphabet[digit]);
    }

    return String.fromCharCodes(output);
  }
}

///Decodes a String of Base83-characters into the integral value it represents.
class Base83Decoder extends Converter<String, int> {
  /// Decoder constructor.
  const Base83Decoder();

  @override
  int convert(String input) {
    var result = 0;
    for (final c in input.codeUnits) {
      final digit = _reverse[c];

      if (digit == null) {
        throw ArgumentError('The given string contains invalid characters.');
      }

      result *= 83;
      result += digit;
    }

    return result;
  }
}

/// Contains methods to encode or decode integers to Base83-Strings.
class Base83 {
  /// Constructor.
  Base83(int length)
      : decoder = const Base83Decoder(),
        encoder = Base83Encoder(length);

  /// Decoder interface.
  final Base83Decoder decoder;

  /// Encoder interface.
  final Base83Encoder encoder;

  /// Encodes an int to String.
  String encode(int input) => encoder.convert(input);

  /// Decodes a String to int.
  int decode(String input) => decoder.convert(input);
}

/// Created a Base83 instance.
Base83 base83(int length) => Base83(length);

const _decoder = Base83Decoder();

/// Decodes a String to int.
int base83Decode(String input) => _decoder.convert(input);

/// Encodes an int to String.
String base83Encode(int input, int length) => base83(length).encode(input);
