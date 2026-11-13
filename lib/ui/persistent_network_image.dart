import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'image_bytes_loader_stub.dart'
    if (dart.library.io) 'image_bytes_loader_io.dart'
    as image_loader;

@immutable
class PersistentNetworkImage extends ImageProvider<PersistentNetworkImage> {
  const PersistentNetworkImage(this.url);

  final String url;

  @override
  Future<PersistentNetworkImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<PersistentNetworkImage>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    PersistentNetworkImage key,
    ImageDecoderCallback decode,
  ) {
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode, chunkEvents),
      chunkEvents: chunkEvents.stream,
      scale: 1,
      debugLabel: key.url,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PersistentNetworkImage && other.url == url;
  }

  @override
  int get hashCode => Object.hash(runtimeType, url);

  Future<ui.Codec> _loadAsync(
    PersistentNetworkImage key,
    ImageDecoderCallback decode,
    StreamController<ImageChunkEvent> chunkEvents,
  ) async {
    try {
      final Uint8List bytes = await image_loader.loadImageBytes(
        key.url,
        onProgress: (int cumulativeBytesLoaded, int? expectedTotalBytes) {
          chunkEvents.add(
            ImageChunkEvent(
              cumulativeBytesLoaded: cumulativeBytesLoaded,
              expectedTotalBytes: expectedTotalBytes,
            ),
          );
        },
      );
      final ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(
        bytes,
      );
      return await decode(buffer);
    } finally {
      await chunkEvents.close();
    }
  }
}
