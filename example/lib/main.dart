import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:lifehash/lifehash.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _body;

  @override
  void didChangeDependencies() {
    _body = demoGallery(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lifehash Demo')),
      body: Center(child: _body),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Examples'),
            ),
            ListTile(
              title: Text('Demo gallery'),
              onTap: () {
                setState(() {
                  _body = demoGallery(context);
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('BitFlip'),
              onTap: () {
                setState(() {
                  _body = flippingBits(context);
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget flippingBits(BuildContext context) {
  var bytes = sha256.convert(utf8.encode('BitFlip')).bytes;
  List<int> flipIthBit(int index) {
    List<int> result = List.from(bytes);
    var bitIdx = index % 8;
    var byteIdx = ((index - bitIdx) / 8).round();
    result[byteIdx] = result[byteIdx] ^ (1 << (7 - bitIdx));
    return result;
  }

  return Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          'Starting from x=sha256(utf8("BitFlip")), the i-th picture shows the lifehash of x with the i-th bit flipped',
          textAlign: TextAlign.center,
        ),
      ),
      Expanded(
        child: lifehashGrid(256, flipIthBit),
      )
    ],
  );
}

Widget demoGallery(BuildContext context) {
  return Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          'The i-th picture shows the lifehash of utf8(string(i))',
          textAlign: TextAlign.center,
        ),
      ),
      Expanded(
        child: lifehashGrid(
          256,
          (i) => utf8.encode(i.toString()),
        ),
      )
    ],
  );
}

Widget lifehashGrid(int count, Function ithBytes) {
  var size = 5.0;
  return Padding(
    padding: EdgeInsets.only(top: 20),
    child: GridView.count(
      crossAxisCount: 2,
      children: List.generate(
        count,
        (index) => Container(
          height: size * 32 + 20,
          width: size * 32,
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  width: 32 * size,
                  height: 32 * size,
                  child: CustomPaint(
                    painter: LifehashPainter(
                      size,
                      ithBytes(index),
                    ),
                  ),
                ),
                Text(index.toString())
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class LifehashPainter extends CustomPainter {
  LifehashPainter(this.size, this.bytes);
  final double size;
  final List<int> bytes;

  @override
  void paint(Canvas canvas, Size _size) {
    var paint = Paint()..style = PaintingStyle.fill;
    var colors = lifehash(bytes, Version.v1);
    for (var x = 0; x < 32; x++) {
      for (var y = 0; y < 32; y++) {
        paint.color = colors[y][x];
        canvas.drawRect(Offset(x * size, y * size) & Size(size, size), paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
