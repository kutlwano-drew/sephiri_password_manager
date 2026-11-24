import 'dart:convert';
import 'dart:typed_data';

Uint8List utf8Bytes(String value) => Uint8List.fromList(utf8.encode(value));
String utf8String(List<int> value) => utf8.decode(value);
String base64UrlEncodeBytes(List<int> bytes) => base64UrlEncode(bytes).replaceAll('=', '');
Uint8List base64UrlDecodeBytes(String value) => Uint8List.fromList(base64Url.decode(base64Url.normalize(value)));
