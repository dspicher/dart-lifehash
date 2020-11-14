import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:lifehash/conway.dart';

void main() {
  group('iteration', () {
    test('leaves all-zero state intact', () {
      var zero = Grid.zero(10);
      var initial = zero.state;
      zero.evolve();
      expect(zero.state, initial);
    });

    test('keeps block static', () {
      var block = Grid.zero(4);
      block.set(1, 1, true);
      block.set(1, 2, true);
      block.set(2, 1, true);
      block.set(2, 2, true);
      var initial = block.state;
      block.evolve();
      expect(block.state, initial);
    });

    test('oscillates the blinker', () {
      var osc = Grid.zero(5);
      osc.set(2, 1, true);
      osc.set(2, 2, true);
      osc.set(2, 3, true);
      var initial = osc.state;
      osc.evolve();
      expect(osc.state, isNot(equals(initial)));
      osc.evolve();
      expect(osc.state, initial);
    });

    test('wraps the glider around', () {
      var glider = Grid.zero(5);
      glider.set(1, 2, true);
      glider.set(2, 0, true);
      glider.set(2, 2, true);
      glider.set(3, 1, true);
      glider.set(3, 2, true);
      var initial = glider.state;
      for (int i = 0; i < 5 * 4; i++) {
        glider.evolve();
      }
      expect(glider.state, initial);
    });

    test('correctly initializes', () {
      var digest = sha256.convert(utf8.encode("foo"));
      var bytes = digest.bytes;
      var grid = Grid.digest(digest);
      for (int row = 0; row < 16; row++) {
        var firstByte = bytes[2 * row];
        for (int i = 0; i < 8; i++) {
          expect(grid.state[row][i], 1 & firstByte >> (7 - i));
        }
        var secondByte = bytes[2 * row + 1];
        for (int i = 0; i < 8; i++) {
          expect(grid.state[row][8 + i], 1 & secondByte >> (7 - i));
        }
      }
    });
  });
  group('converge', () {
    test('returns a single state for the static block', () {
      var block = Grid.zero(4);
      block.set(1, 1, true);
      block.set(1, 2, true);
      block.set(2, 1, true);
      block.set(2, 2, true);
      var initial = block.state;
      var states = converge(block, 10);
      expect(states.length, 1);
      expect(states[0], initial);
    });

    test('returns two states for the blinker', () {
      var osc = Grid.zero(5);
      osc.set(2, 1, true);
      osc.set(2, 2, true);
      osc.set(2, 3, true);
      var initial = osc.state;
      var states = converge(osc, 10);
      expect(states.length, 2);
      expect(states[0], initial);
      var second = Grid.zero(5);
      second.set(1, 2, true);
      second.set(2, 2, true);
      second.set(3, 2, true);
      expect(states[1], second.state);
    });

    test('returns 20 states for the glider', () {
      var glider = Grid.zero(5);
      glider.set(1, 2, true);
      glider.set(2, 0, true);
      glider.set(2, 2, true);
      glider.set(3, 1, true);
      glider.set(3, 2, true);
      var states = converge(glider, 10);
      expect(states.length, 10);
      states = converge(glider, 100);
      expect(states.length, 20);
    });
  });
}
