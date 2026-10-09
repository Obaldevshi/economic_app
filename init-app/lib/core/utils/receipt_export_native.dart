import 'dart:typed_data';
import 'package:flutter/services.dart';

Future<void> exportReceipt(Uint8List bytes) async {
  await const MethodChannel(
    'not_spent/native',
  ).invokeMethod<void>('shareReceipt', bytes);
}
