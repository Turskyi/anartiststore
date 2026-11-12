import 'package:flutter/services.dart';

Future<Uint8List> loadImageBytes(String url) async {
  final ByteData data = await NetworkAssetBundle(Uri.parse(url)).load(url);
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}
