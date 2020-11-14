import 'package:flutter_test/flutter_test.dart';
import 'package:lifehash/symmetry.dart';

void main() {
  group('symmetry', () {
    test('correctly constructs snowflake symmetry', () {
      var values = [
        [1.0, 2.0, 3.0],
        [4.0, 5.0, 6.0],
        [7.0, 8.0, 9.0]
      ];
      expect(snowflake(values), [
        [1.0, 2.0, 3.0, 3.0, 2.0, 1.0],
        [4.0, 5.0, 6.0, 6.0, 5.0, 4.0],
        [7.0, 8.0, 9.0, 9.0, 8.0, 7.0],
        [7.0, 8.0, 9.0, 9.0, 8.0, 7.0],
        [4.0, 5.0, 6.0, 6.0, 5.0, 4.0],
        [1.0, 2.0, 3.0, 3.0, 2.0, 1.0],
      ]);
    });

    test('correctly constructs pinwheel symmetry', () {
      var values = [
        [1.0, 2.0, 3.0],
        [4.0, 5.0, 6.0],
        [7.0, 8.0, 9.0]
      ];
      expect(pinwheel(values), [
        [1.0, 2.0, 3.0, 7.0, 4.0, 1.0],
        [4.0, 5.0, 6.0, 8.0, 5.0, 2.0],
        [7.0, 8.0, 9.0, 9.0, 6.0, 3.0],
        [3.0, 6.0, 9.0, 9.0, 8.0, 7.0],
        [2.0, 5.0, 8.0, 6.0, 5.0, 4.0],
        [1.0, 4.0, 7.0, 3.0, 2.0, 1.0],
      ]);
    });
  });
}
