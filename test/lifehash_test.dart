import 'package:flutter_test/flutter_test.dart';
import 'package:lifehash/conway.dart';
import 'package:lifehash/lifehash.dart';

void main() {
  group('grayscale', () {
    test('returns correctly for blinker', () {
      var osc = Grid.zero(5);
      osc.set(2, 1, true);
      osc.set(2, 2, true);
      osc.set(2, 3, true);
      var gray = grayscale(osc);
      expect(gray, [
        [0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0],
        [0, 0.5, 1, 0.5, 0],
        [0, 0, 1, 0, 0],
        [0, 0, 0, 0, 0],
      ]);
    });
  });
}
