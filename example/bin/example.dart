import 'package:base83/base83.dart';

void main(List<String> arguments) {
  final output = base83(4).encoder.convert(1092);

  // 00DD
  print(output);
}
