import 'dart:convert';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifehash/conway.dart';
import 'package:lifehash/lifehash.dart';

void main() {
  group('grayscale', () {
    test('returns correctly for blinker', () {
      var osc = Grid.zero(5)..set(2, 1, true)..set(2, 2, true)..set(2, 3, true);
      var gray = grayscale(osc, Version.v1);
      expect(gray, [
        [0, 0, 0, 0, 0],
        [0, 0, 1, 0, 0],
        [0, 0.5, 1, 0.5, 0],
        [0, 0, 1, 0, 0],
        [0, 0, 0, 0, 0],
      ]);
    });
  });

  group('lifehash', () {
    test('returns correctly for "lifehash"', () {
      var lh =
          lifehash(sha256.convert(utf8.encode('lifehash')).bytes, Version.v1);
      var diagonal = [
        Color(0xff43a5c6),
        Color(0xff43a5c6),
        Color(0xff4bb3d2),
        Color(0xffade1da),
        Color(0xffade1da),
        Color(0xffade1da),
        Color(0xffabe0da),
        Color(0xff9ddbdb),
        Color(0xff9ddbdb),
        Color(0xff86d4dc),
        Color(0xff7fd1dd),
        Color(0xff0d3156),
        Color(0xff0d294d),
        Color(0xff0d2c50),
        Color(0xff3189ae),
        Color(0xff43a5c6),
      ];
      for (int i = 0; i < 16; i++) {
        expect(lh[i][i], diagonal[i]);
      }
    });
  });
}
