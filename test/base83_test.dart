import 'package:base83/base83.dart';
import 'package:test/test.dart';

void main() {
  test('Encoding', () {
    expect(base83(2).encode(1092), 'DD');
    expect(base83(4).encode(1092), '00DD');
    expect(base83(2).encode(1337), 'G9');
    expect(base83(4).encode(1337), '00G9');
    expect(base83(2).encode(83), '10');
    expect(base83(3).encode(83), '010');
  });

  test('Decoding', () {
    expect(base83(2).decode('10'), 83);
    expect(base83(4).decode('010'), 83);
    expect(base83(2).decode('DD'), 1092);
    expect(base83(4).decode('0DD'), 1092);
    expect(base83(2).decode('G9'), 1337);
    expect(base83(3).decode('0G9'), 1337);
  });
}
