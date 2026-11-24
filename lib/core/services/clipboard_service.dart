import 'dart:async';
import 'package:flutter/services.dart';

class ClipboardService {
  Timer? _timer;

  Future<void> copySensitive(String value, {Duration duration = const Duration(seconds: 30)}) async {
    _timer?.cancel();
    await Clipboard.setData(ClipboardData(text: value));
    _timer = Timer(duration, () async {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data?.text == value) await Clipboard.setData(const ClipboardData(text: ''));
    });
  }

  void dispose() => _timer?.cancel();
}
