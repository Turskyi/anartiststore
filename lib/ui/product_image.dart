import 'package:anartiststore/ui/persistent_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_translate/flutter_translate.dart';

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
      errorBuilder: (BuildContext _, Object _, StackTrace? _) {
        return Center(child: Text(translate('error_loading_image')));
      },
    );
  }
}
