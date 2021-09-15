import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:lifehash/entropy.dart';
import 'package:lifehash/lifehash.dart';

List<Color> chooseGradient(Entropy entropy, Version version) {
  if (version == Version.grayscale_fiducial) {
    return chooseGrayscale(entropy);
  }

  return entropy.nextBool()
      ? (entropy.nextBool()
          ? analgousGradient(entropy, spectrumColor)
          : triadicGradient(entropy, spectrumColor))
      : (entropy.nextBool()
          ? complementaryGradient(entropy, spectrumColor)
          : monochromeGradient(entropy, hsbColor));
}

Color hsbColor(double hue) {
  return HSVColor.fromAHSV(1, 360.0 * hue, 1, 1).toColor();
}

List<Color> chooseGrayscale(Entropy entropy) {}

List<Color> complementaryGradient(Entropy entropy, Function hueGenerator) {
  var spectrum1 = entropy.nextFrac();
  var lighterAdvance = entropy.nextFrac() * 0.3;
  var darkerAdvance = entropy.nextFrac() * 0.3;
  bool isReversed = entropy.nextBool();
  var spectrum2 = (spectrum1 + 0.5) % 1;
  var color1 = hueGenerator(spectrum1);
  var color2 = hueGenerator(spectrum2);
  var darkerColor;
  var lighterColor;
  if (color1.computeLuminance() > color2.computeLuminance()) {
    darkerColor = color2;
    lighterColor = color1;
  } else {
    darkerColor = color1;
    lighterColor = color2;
  }
  var adjustedLighter = Color.lerp(lighterColor, white, lighterAdvance);
  var adjustedDarker = Color.lerp(darkerColor, black, darkerAdvance);
  var colors = [adjustedDarker, adjustedLighter];
  return isReversed ? colors.reversed.toList() : colors;
}

List<Color> triadicGradient(Entropy entropy, Function hueGenerator) {
  var spectrum1 = entropy.nextFrac();
  var spectrum2 = (spectrum1 + 1 / 3) % 1;
  var spectrum3 = (spectrum1 + 2 / 3) % 1;
  var lighterAdvance = entropy.nextFrac() * 0.3;
  var darkerAdvance = entropy.nextFrac() * 0.3;
  bool isReversed = entropy.nextBool();

  var colors = [spectrum1, spectrum2, spectrum3].map(hueGenerator).toList()
    ..sort((col1, col2) => (luminance(col1).compareTo(luminance(col2))));
  var adjustedLighter = Color.lerp(colors[2], white, lighterAdvance);
  var adjustedDarker = Color.lerp(colors[0], black, darkerAdvance);
  var gradientColors = [adjustedLighter, colors[1], adjustedDarker];
  return isReversed ? gradientColors.reversed.toList() : gradientColors;
}

List<Color> analgousGradient(Entropy entropy, Function hueGenerator) {
  var spectrum1 = entropy.nextFrac();
  var advance = entropy.nextFrac() * 0.5 + 0.2;
  bool isReversed = entropy.nextBool();

  var spectrum2 = (spectrum1 + 1 / 12) % 1;
  var spectrum3 = (spectrum1 + 2 / 12) % 1;
  var spectrum4 = (spectrum1 + 3 / 12) % 1;
  var colors =
      [spectrum1, spectrum2, spectrum3, spectrum4].map(hueGenerator).toList();
  if (colors[0].computeLuminance() > colors[3].computeLuminance()) {
    colors = colors.reversed.toList();
  }
  var adjustedDarkest = Color.lerp(colors[0], black, advance);
  var adjustedDark = Color.lerp(colors[1], black, advance / 2);
  var adjustedLight = Color.lerp(colors[2], white, advance / 2);
  var adjustedLightest = Color.lerp(colors[3], white, advance);
  var gradientColors = [
    adjustedDarkest,
    adjustedDark,
    adjustedLight,
    adjustedLightest
  ];
  return isReversed ? gradientColors.reversed.toList() : gradientColors;
}

List<Color> monochromeGradient(Entropy entropy, Function hueGenerator) {
  double hue = entropy.nextFrac();
  bool isTint = entropy.nextBool();
  bool isReversed = entropy.nextBool();
  double keyAdvance = entropy.nextFrac() * 0.3 + 0.05;
  double neutralAdvance = entropy.nextFrac() * 0.3 + 0.05;
  var keyColor = hueGenerator(hue);
  var contrastBrightness = isTint ? 1.0 : 0.0;
  if (isTint) {
    keyColor = keyColor.withRed((keyColor.red / 2).round());
    keyColor = keyColor.withGreen((keyColor.green / 2).round());
    keyColor = keyColor.withBlue((keyColor.blue / 2).round());
  }
  var neutralColor = HSVColor.fromAHSV(1, 0, 0, contrastBrightness).toColor();
  var keyColor2 = Color.lerp(keyColor, neutralColor, keyAdvance);
  var neutralColor2 = Color.lerp(neutralColor, keyColor, neutralAdvance);
  var colors = [keyColor2, neutralColor2];
  return isReversed ? colors.reversed.toList() : colors;
}

Color spectrumColor(double frac) {
  return lerpMany(spectrumColors, frac);
}

Color cmykSafespectrumColor(double frac) {
  return lerpMany(spectrumCMYKSafe, frac);
}

Color lerpMany(List<Color> colors, double frac) {
  int n = colors.length;
  var fracs = Iterable<int>.generate(n).map((x) => x / (n - 1)).toList();
  var fractionalLeftIndex = fracs.lastWhere((f) => frac >= f);
  var leftIndex = (fractionalLeftIndex * (n - 1)).round();
  if (leftIndex == n - 1) {
    return colors.last;
  }
  var scaledFrac =
      (frac - fracs[leftIndex]) / (fracs[leftIndex + 1] - fracs[leftIndex]);
  // round to 8 decimal places
  scaledFrac = (pow(10, 8) * scaledFrac).round() / pow(10, 8);
  return Color.lerp(colors[leftIndex], colors[leftIndex + 1], scaledFrac);
}

const Color black = Color.fromARGB(255, 0, 0, 0);
const Color white = Color.fromARGB(255, 255, 255, 255);

const spectrumColors = [
  Color.fromARGB(255, 0, 168, 222),
  Color.fromARGB(255, 51, 51, 145),
  Color.fromARGB(255, 233, 19, 136),
  Color.fromARGB(255, 235, 45, 46),
  Color.fromARGB(255, 253, 233, 43),
  Color.fromARGB(255, 0, 158, 84),
  Color.fromARGB(255, 0, 168, 222),
];

const spectrumCMYKSafe = [
  Color.fromARGB(255, 0, 168, 222),
  Color.fromARGB(255, 41, 60, 130),
  Color.fromARGB(255, 210, 59, 130),
  Color.fromARGB(255, 217, 63, 53),
  Color.fromARGB(255, 244, 228, 81),
  Color.fromARGB(255, 0, 158, 84),
  Color.fromARGB(255, 0, 168, 222),
];

double luminance(Color color) {
  return 0.2126 * color.red + 0.7152 * color.green + 0.0722 * color.blue;
}
