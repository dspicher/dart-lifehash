import 'dart:math';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:lifehash/color.dart';
import 'package:lifehash/conway.dart';
import 'package:lifehash/entropy.dart';
import 'package:lifehash/symmetry.dart';

enum Version { v1, v2, detailed, fiducial, grayscale_fiducial }

List<List<double>> grayscale(Grid grid, Version version) {
  var maxIter = version == Version.v1 || version == Version.v2 ? 150 : 300;
  var states = converge(grid, maxIter);
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
  var digest = sha256.convert(bytes).bytes;
  var initialGrid;
  switch (version) {
    case Version.v1:
      initialGrid = digest;
      break;
    case Version.v2:
      initialGrid = sha256.convert(digest).bytes;
      break;
    case Version.detailed:
    case Version.fiducial:
    case Version.grayscale_fiducial:
      var digest1;
      if (version == Version.grayscale_fiducial) {
        digest1 = sha256.convert(digest);
      } else {
        digest1 = digest;
      }
      var digest2 = sha256.convert(digest1).bytes;
      var digest3 = sha256.convert(digest2).bytes;
      var digest4 = sha256.convert(digest3).bytes;
      initialGrid = digest1 + digest2 + digest3 + digest4;
      break;
  }
  var grayValues = grayscale(Grid.bytes(initialGrid), version);
  if (version != Version.v1) {
    grayValues = lerp(grayValues);
  }
  var entropy = Entropy.fromBytes(digest);
  if (version == Version.detailed) {
    entropy.nextBool();
  } else if (version == Version.v2) {
    entropy.nextUInt(2);
  }
  var colors = chooseGradient(entropy);
  var symmetric =
      entropy.nextBool() ? snowflake(grayValues) : pinwheel(grayValues);
  return symmetric
      .map((l) => l.map((f) => lerpMany(colors, f)).toList())
      .toList();
}

List<List<double>> lerp(List<List<double>> values) {
  var minValue = values.map((l) => l.reduce(min)).reduce(min);
  var maxValue = values.map((l) => l.reduce(max)).reduce(max);
  return values
      .map((l) => l.map((e) => (e - minValue) / (maxValue - minValue)).toList())
      .toList();
}
