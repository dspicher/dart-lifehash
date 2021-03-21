import 'dart:collection';

import 'package:flutter/cupertino.dart';

final neighbours = [
  [-1, -1],
  [-1, 0],
  [-1, 1],
  [0, -1],
  [0, 1],
  [1, -1],
  [1, 0],
  [1, 1]
];

class Grid {
  Grid.zero(this.size) {
    state = List.generate(size, (_) => List.generate(size, (_) => 0));
  }

  Grid.bytes(List<int> bytes) {
    if (bytes.length == 32) {
      size = 16;
    } else if (bytes.length == 128) {
      size = 32;
    } else {
      throw Exception('invalid implied size');
    }
    int bytesPerRow = (size / 8).round();
    state = List.generate(size, (_) => List.generate(size, (_) => 0));
    for (int row = 0; row < size; row++) {
      for (int j = 0; j < bytesPerRow; j++) {
        var byte = bytes[bytesPerRow * row + j];
        for (int i = 0; i < 8; i++) {
          state[row][8 * j + 7 - i] = byte >> i & 1;
        }
      }
    }
  }

  List<List<int>> state;
  int size;

  void set(int x, int y, bool alive) {
    state[x][y] = alive ? 1 : 0;
  }

  int hash() {
    return hashList(state.map(hashList));
  }

  void evolve() {
    var newGrid = List.generate(size, (_) => List.generate(size, (_) => 0));
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        int neighbourCount = neighbours
            .map((p) => state[(i + p[0]) % size][(j + p[1]) % size])
            .reduce((a, b) => a + b);
        if (state[i][j] > 0) {
          if (neighbourCount >= 2 && neighbourCount <= 3) {
            newGrid[i][j] = 1;
          }
        } else {
          if (neighbourCount == 3) {
            newGrid[i][j] = 1;
          }
        }
      }
    }
    state = newGrid;
  }
}

List<List<List<int>>> converge(Grid grid, int maxIter) {
  var allStates = [grid.state];
  var encountered = HashSet<int>()..add(grid.hash());
  for (int i = 1; i < maxIter; i++) {
    grid.evolve();
    if (encountered.contains(grid.hash())) {
      break;
    }
    allStates.add(grid.state);
    encountered.add(grid.hash());
  }
  return allStates;
}
