import 'dart:async';

import 'package:flutter/services.dart';

class FlutterJdKepler {
  static const MethodChannel _channel =
      const MethodChannel('flutter_jd_kepler');

  static Future<bool> init(final String appKey, final String appSecret) async {
    return await _channel.invokeMethod('init', {
      'appKey': appKey,
      'appSecret': appSecret,
    });
  }

  static Future<bool> isLogin() async {
    return await _channel.invokeMethod('isLogin');
  }

  static Future<bool> login() async {
    return await _channel.invokeMethod('login');
  }

  static Future<bool> logout() async {
    await _channel.invokeMethod('logout');
    return true;
  }
}
