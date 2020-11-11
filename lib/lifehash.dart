
import 'dart:async';

import 'package:flutter/services.dart';

class Lifehash {
  static const MethodChannel _channel =
      const MethodChannel('lifehash');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
