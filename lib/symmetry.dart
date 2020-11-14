List<List<double>> snowflake(List<List<double>> values) {
  var size = values.length;
  var result =
      List.generate(2 * size, (_) => List.generate(2 * size, (_) => 0.0));
  // upper left: unchanged
  for (int x = 0; x < size; x++) {
    for (int y = 0; y < size; y++) {
      result[x][y] = values[x][y];
    }
  }
  // upper right: flipped along vertical
  for (int x = 0; x < size; x++) {
    for (int y = 0; y < size; y++) {
      result[x][size + y] = values[x][size - 1 - y];
    }
  }
  // lower left: flipped along horizontal
  for (int x = 0; x < size; x++) {
    for (int y = 0; y < size; y++) {
      result[size + x][y] = values[size - 1 - x][y];
    }
  }
  // lower right: both flipped
  for (int x = 0; x < size; x++) {
    for (int y = 0; y < size; y++) {
      result[size + x][size + y] = values[size - 1 - x][size - 1 - y];
    }
  }
  return result;
}

List<List<double>> pinwheel(List<List<double>> values) {
  var size = values.length;
  var result =
      List.generate(2 * size, (_) => List.generate(2 * size, (_) => 0.0));
  // upper left: unchanged
  for (int x = 0; x < size; x++) {
    for (int y = 0; y < size; y++) {
      result[x][y] = values[x][y];
    }
  }
  // upper right: transpose and flip along vertical
  for (int x = 0; x < size; x++) {
    for (int y = 0; y < size; y++) {
      result[x][size + y] = values[size - 1 - y][x];
    }
  }
  // lower left: transpose and flip along horizontal
  for (int x = 0; x < size; x++) {
    for (int y = 0; y < size; y++) {
      result[size + x][y] = values[y][size - 1 - x];
    }
  }
  // lower right: both flipped
  for (int x = 0; x < size; x++) {
    for (int y = 0; y < size; y++) {
      result[size + x][size + y] = values[size - 1 - x][size - 1 - y];
    }
  }
  return result;
}
