import 'dart:convert';
import 'dart:typed_data';
import 'package:web/web.dart' as web;

Future<void> exportReceipt(Uint8List bytes) async {
  final anchor = web.HTMLAnchorElement()
    ..href = 'data:image/png;base64,${base64Encode(bytes)}'
    ..download = 'not-spent-receipt.png';
  web.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
}
