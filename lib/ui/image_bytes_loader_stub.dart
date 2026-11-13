import 'package:flutter/services.dart';

Future<Uint8List> loadImageBytes(
  String url, {
  required void Function(int cumulativeBytesLoaded, int? expectedTotalBytes)
  onProgress,
}) async {
  final ByteData data = await NetworkAssetBundle(Uri.parse(url)).load(url);
  final Uint8List bytes = data.buffer.asUint8List(
    data.offsetInBytes,
    data.lengthInBytes,
  );
  onProgress(bytes.length, bytes.length);
  return bytes;
}
