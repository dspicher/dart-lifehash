class Entropy {
  Entropy.fromBytes(List<int> bytes) {
    List<int> bits = [];
    for (var byte in bytes) {
      for (int i = 0; i < 8; i++) {
        bits.add(byte >> (7 - i) & 1);
      }
    }
    this.remainingBits = bits;
  }

  List<int> remainingBits;

  bool nextBool() {
    var value = this.remainingBits.removeAt(0);
    return value > 0;
  }

  int nextUInt(int bits) {
    var result = 0;
    for (int i = 0; i < bits; i++) {
      var currentBit = this.remainingBits.removeAt(0);
      result = result << 1;
      result = result | currentBit;
    }
    return result;
  }

  double nextFrac() {
    return nextUInt(16) / 65535;
  }
}
