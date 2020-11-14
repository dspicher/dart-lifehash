import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:lifehash/entropy.dart';

List<Color> chooseGradient(Entropy entropy) {
  return entropy.nextBool()
      ? (entropy.nextBool() ? chooseAnalogous(entropy) : choosetriadic(entropy))
      : (entropy.nextBool()
          ? chooseComplementary(entropy)
          : chooseMonochrome(entropy));
}

List<Color> chooseComplementary(Entropy entropy) {
  var spectrum = entropy.nextFrac();
  var lighterAdvance = entropy.nextFrac();
  var darkerAdvance = entropy.nextFrac();
  bool isReversed = entropy.nextBool();
  return complementaryGradient(
      spectrum, lighterAdvance, darkerAdvance, isReversed);
}

List<Color> complementaryGradient(double spectrum, double lighterAdvance,
    double darkerAdvance, bool isReversed) {
  var spectrum2 = (spectrum + 0.5) % 1;
  var color1 = spectrumColor(spectrum);
  var color2 = spectrumColor(spectrum2);
  var darkerColor;
  var lighterColor;
  if (color1.computeLuminance() > color2.computeLuminance()) {
    darkerColor = color2;
    lighterColor = color1;
  } else {
    darkerColor = color1;
    lighterColor = color2;
  }
  var adjustedLighter = Color.lerp(lighterColor, white, lighterAdvance * 0.3);
  var adjustedDarker = Color.lerp(darkerColor, black, darkerAdvance * 0.3);
  var colors = [adjustedDarker, adjustedLighter];
  return isReversed ? colors.reversed.toList() : colors;
}

List<Color> choosetriadic(Entropy entropy) {
  var spectrum = entropy.nextFrac();
  var lighterAdvance = entropy.nextFrac();
  var darkerAdvance = entropy.nextFrac();
  bool isReversed = entropy.nextBool();
  return triadicGradient(spectrum, lighterAdvance, darkerAdvance, isReversed);
}

List<Color> triadicGradient(double spectrum, double lighterAdvance,
    double darkerAdvance, bool isReversed) {
  var spectrum2 = (spectrum + 1 / 3) % 1;
  var spectrum3 = (spectrum + 2 / 3) % 1;
  var colors = [spectrum, spectrum2, spectrum3].map(spectrumColor).toList()
    ..sort((col1, col2) =>
        (col1.computeLuminance() - col2.computeLuminance()).ceil());
  var adjustedLighter = Color.lerp(colors[2], white, lighterAdvance * 0.3);
  var adjustedDarker = Color.lerp(colors[0], black, darkerAdvance * 0.3);
  var gradientColors = [adjustedLighter, colors[1], adjustedDarker];
  return isReversed ? gradientColors.reversed.toList() : gradientColors;
}

List<Color> chooseAnalogous(Entropy entropy) {
  var spectrum = entropy.nextFrac();
  var advance = entropy.nextFrac();
  bool isReversed = entropy.nextBool();
  return analgousGradient(spectrum, advance, isReversed);
}

List<Color> analgousGradient(
    double spectrum1, double advance, bool isReversed) {
  var spectrum2 = (spectrum1 + 1 / 12) % 1;
  var spectrum3 = (spectrum1 + 2 / 12) % 1;
  var spectrum4 = (spectrum1 + 3 / 12) % 1;
  var colors =
      [spectrum1, spectrum2, spectrum3, spectrum4].map(spectrumColor).toList();
  if (colors[0].computeLuminance() > colors[3].computeLuminance()) {
    colors = colors.reversed.toList();
  }
  var adjustedAdvance = advance * 0.5 + 0.2;
  var adjustedDarkest = Color.lerp(colors[0], black, adjustedAdvance);
  var adjustedDark = Color.lerp(colors[1], black, adjustedAdvance / 2);
  var adjustedLight = Color.lerp(colors[2], white, adjustedAdvance / 2);
  var adjustedLightest = Color.lerp(colors[3], white, adjustedAdvance);
  var gradientColors = [
    adjustedDarkest,
    adjustedDark,
    adjustedLight,
    adjustedLightest
  ];
  return isReversed ? gradientColors.reversed.toList() : gradientColors;
}

List<Color> chooseMonochrome(Entropy entropy) {
  double hue = entropy.nextFrac();
  bool isTint = entropy.nextBool();
  bool isReversed = entropy.nextBool();
  double keyAdvance = entropy.nextFrac();
  double neutralAdvance = entropy.nextFrac();
  return monochromeGradient(
      hue, isTint, isReversed, keyAdvance, neutralAdvance);
}

List<Color> monochromeGradient(double hue, bool isTint, bool isReversed,
    double keyAdvance, double neutralAdvance) {
  var keyColor = HSVColor.fromAHSV(1, hue, 1, 1).toColor();
  var contrastBrightness = isTint ? 1.0 : 0.0;
  if (isTint) {
    keyColor.withRed((keyColor.red * 2 / 3).round())
      ..withGreen((keyColor.green * 2 / 3).round())
      ..withBlue((keyColor.blue * 2 / 3).round());
  }
  var neutralColor = HSVColor.fromAHSV(1, 0, 0, contrastBrightness).toColor();
  var keyColor2 = Color.lerp(keyColor, neutralColor, keyAdvance * 0.3 + 0.05);
  var neutralColor2 =
      Color.lerp(neutralColor, keyColor, keyAdvance * 0.3 + 0.05);
  var colors = [keyColor2, neutralColor2];
  return isReversed ? colors.reversed.toList() : colors;
}

Color spectrumColor(double frac) {
  return lerpMany(spectrumColors, frac);
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
