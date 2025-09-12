import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web/web.dart' as web;

void replaceUrl(String path) {
  if (kIsWeb) {
    web.window.history.replaceState(null, '', path);
  }
}
