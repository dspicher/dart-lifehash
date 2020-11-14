import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:lifehash/color.dart';

void main() {
  group('lerpMany', () {
    test('correctly interpolates spectrum colors', () {
      for (int i = 0; i < 7; i++) {
        expect(spectrumColor(i / 6), spectrumColors[i]);
      }
      for (int i = 0; i < 6; i++) {
        expect(spectrumColor(i / 6 + 1 / 12),
            Color.lerp(spectrumColors[i], spectrumColors[i + 1], 0.5));
      }
    });
  });
}
