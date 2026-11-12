import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

final Dio _imageDio = Dio();

Future<Uint8List> loadImageBytes(String url) async {
  final Directory appSupportDirectory = await getApplicationSupportDirectory();
  final Directory imageCacheDirectory = Directory(
    '${appSupportDirectory.path}${Platform.pathSeparator}product_image_cache',
  );
  final File cachedImage = File(
    '${imageCacheDirectory.path}${Platform.pathSeparator}'
    '${_cacheFileName(url)}',
  );

  if (await cachedImage.exists()) {
    return cachedImage.readAsBytes();
  } else {
    final Response<List<int>> response = await _imageDio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    final List<int>? responseBytes = response.data;
    if (responseBytes == null || responseBytes.isEmpty) {
      throw StateError('The image response was empty for $url.');
    }

    final Uint8List bytes = Uint8List.fromList(responseBytes);
    try {
      await imageCacheDirectory.create(recursive: true);
      await cachedImage.writeAsBytes(bytes, flush: true);
    } on FileSystemException catch (error, stackTrace) {
      debugPrint('Could not persist a product image: $error\n$stackTrace');
    }
    return bytes;
  }
}

String _cacheFileName(String url) {
  const int mask = 0xffffffff;
  int firstHash = 0x811c9dc5;
  int secondHash = 0x9e3779b9;
  final List<int> urlBytes = utf8.encode(url);

  for (int index = 0; index < urlBytes.length; index++) {
    final int byte = urlBytes[index];
    firstHash = ((firstHash ^ byte) * 0x01000193) & mask;
    secondHash = ((secondHash ^ (byte + index)) * 0x85ebca6b) & mask;
  }

  return '${firstHash.toRadixString(16).padLeft(8, '0')}'
      '${secondHash.toRadixString(16).padLeft(8, '0')}.img';
}
