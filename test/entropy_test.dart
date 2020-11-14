import 'package:flutter_test/flutter_test.dart';
import 'package:lifehash/entropy.dart';

void main() {
  group('entropy', () {
    test('constructor from bytes', () {
      var ent = Entropy.fromBytes([85, 10, 124, 200]);
      var eightyfive = [0, 1, 0, 1, 0, 1, 0, 1];
      var ten = [0, 0, 0, 0, 1, 0, 1, 0];
      var hundredtf = [0, 1, 1, 1, 1, 1, 0, 0];
      var twohundred = [1, 1, 0, 0, 1, 0, 0, 0];
      expect(ent.remainingBits, eightyfive + ten + hundredtf + twohundred);
      expect(ent.nextBool(), false);
      expect(ent.nextBool(), true);
      expect(ent.nextUInt(3), 2);
      expect(ent.nextUInt(7), 80);
      expect(ent.nextUInt(4), 10);
      expect((ent.nextFrac() * 65535).round(), 31944);
    });
  });
}
