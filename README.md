[![pub package](https://img.shields.io/pub/v/base83.svg)](https://pub.dartlang.org/packages/base83)

Blurhash & Base83 encoding and decoding for dart using dart:convert interface.

## Web Demo

[Web Demo](https://blurhash.pwa.ir)

## Getting Started

In your `pubspec.yaml` file add:

```dart
dependencies:
  base83: any
```

Then, in your code import and use the package:

```dart
import 'package:base83/base83.dart';

final number = base83Decode('00DD');
print(number); // 1092
```
