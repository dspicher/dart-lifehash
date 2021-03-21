import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:lifehash/color.dart';
import 'package:lifehash/conway.dart';
import 'package:lifehash/entropy.dart';
import 'package:lifehash/symmetry.dart';

enum Version { v1, v2, detailed, fiducial, grayscale_fiducial }

List<List<double>> grayscale(Grid grid) {
  var states = converge(grid, 150);
  return combineStates(states);
}

List<List<double>> combineStates(List<List<List<int>>> states) {
  var size = states[0].length;
  var result = List.generate(size, (_) => List.generate(size, (_) => 0.0));
  for (int i = 0; i < states.length; i++) {
    for (int x = 0; x < size; x++) {
      for (int y = 0; y < size; y++) {
        if (states[i][x][y] > 0) {
          result[x][y] = (i + 1) / states.length;
        }
      }
    }
  }
  return result;
}

List<List<Color>> lifehash(List<int> bytes, Version version) {
  var digest = sha256.convert(bytes);
  var grayValues = grayscale(Grid.bytes(digest.bytes));
  var entropy = Entropy.fromBytes(digest.bytes);
  var colors = chooseGradient(entropy);
  var symmetric =
      entropy.nextBool() ? snowflake(grayValues) : pinwheel(grayValues);
  return symmetric
      .map((l) => l.map((f) => lerpMany(colors, f)).toList())
      .toList();
}
