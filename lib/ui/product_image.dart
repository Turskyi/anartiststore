import 'package:anartiststore/ui/persistent_network_image.dart';
import 'package:anartiststore/ui/product_image_loading_placeholder.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:material_ui/material_ui.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.imageKey,
    this.excludeFromSemantics = false,
    super.key,
  });

  final bool excludeFromSemantics;
  final BoxFit fit;
  final double? height;
  final Key? imageKey;
  final String imageUrl;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Image(
      key: imageKey,
      image: PersistentNetworkImage(imageUrl),
      fit: fit,
      width: width,
      height: height,
      excludeFromSemantics: excludeFromSemantics,
      frameBuilder:
          (
            BuildContext context,
            Widget child,
            int? frame,
            bool wasSynchronouslyLoaded,
          ) {
            if (frame != null || wasSynchronouslyLoaded) {
              return child;
            } else {
              return const ProductImageLoadingPlaceholder();
            }
          },
      loadingBuilder:
          (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) {
            if (loadingProgress == null) {
              return child;
            } else {
              return ProductImageLoadingPlaceholder(
                loadingProgress: loadingProgress,
              );
            }
          },
      errorBuilder: (BuildContext _, Object _, StackTrace? _) {
        return Center(child: Text(translate('error_loading_image')));
      },
    );
  }
}
