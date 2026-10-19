import 'package:web/web.dart' as web;

void openDownload(String url) {
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..target = '_blank'
    ..rel = 'noopener noreferrer';
  web.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
}
