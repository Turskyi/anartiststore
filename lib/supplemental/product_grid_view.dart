import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:anartiststore/supplemental/mobile_product_card.dart';
import 'package:anartiststore/ui/persistent_network_image.dart';
import 'package:material_ui/material_ui.dart';

class ProductGridView extends StatefulWidget {
  const ProductGridView({
    required this.products,
    required this.preloadProducts,
    super.key,
  });

  final List<Product> products;
  final List<Product> preloadProducts;

  @override
  State<ProductGridView> createState() => _ProductGridViewState();
}

class _ProductGridViewState extends State<ProductGridView> {
  final Map<String, (ImageStream, ImageStreamListener)> _retainedImages =
      <String, (ImageStream, ImageStreamListener)>{};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updatePreloadedImages();
  }

  @override
  void didUpdateWidget(covariant ProductGridView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updatePreloadedImages();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Adapt rows based on height for better desktop/tablet experience
        final int crossAxisCount =
            constraints.maxHeight > constants.kDesktopBreakpoint ? 3 : 2;

        const double spacing = 8.0;
        const EdgeInsets padding = EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 28.0);

        // Calculate the height available for one cell (cross axis)
        final double totalHeight = constraints.maxHeight;
        final double availableHeight =
            totalHeight -
            padding.top -
            padding.bottom -
            (spacing * (crossAxisCount - 1));
        final double cellHeight = availableHeight / crossAxisCount;

        // In MobileProductCard, we have:
        // Column(
        //   children: [
        //     Flexible(child: AspectRatio(1.0, ...)),
        //     SizedBox(height: kTextBoxHeight * textScale),
        //   ]
        // )
        // To keep images square, the image width must equal the image height.
        // Image height = cellHeight - textBoxHeight.
        final double textScale = MediaQuery.textScalerOf(context).scale(1);
        final double textBoxHeight =
            MobileProductCard.kTextBoxHeight * textScale;
        final double imageHeight = cellHeight - textBoxHeight;

        // The cell width (main axis extent) should be equal to the image height
        // to keep the image square 1:1.
        final double cellWidth = imageHeight > 0 ? imageHeight : cellHeight;

        // childAspectRatio for horizontal grid is crossAxisExtent / mainAxisExtent
        // which is height / width.
        final double childAspectRatio = cellHeight / cellWidth;

        return GridView.builder(
          scrollDirection: Axis.horizontal,
          padding: padding,
          itemCount: widget.products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (BuildContext context, int index) {
            return MobileProductCard(
              product: widget.products[index],
              imageAspectRatio: 1.0, // Explicitly square
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    for (final (ImageStream stream, ImageStreamListener listener)
        in _retainedImages.values) {
      stream.removeListener(listener);
    }
    _retainedImages.clear();
    super.dispose();
  }

  void _updatePreloadedImages() {
    final Set<String> imageUrls = widget.preloadProducts
        .map((Product product) => product.imageUrl)
        .toSet();

    final List<String> staleUrls = _retainedImages.keys
        .where((String url) => !imageUrls.contains(url))
        .toList();
    for (final String url in staleUrls) {
      final (ImageStream, ImageStreamListener)? retainedImage = _retainedImages
          .remove(url);
      if (retainedImage != null) {
        final (ImageStream stream, ImageStreamListener listener) =
            retainedImage;
        stream.removeListener(listener);
      }
    }

    final ImageConfiguration configuration = createLocalImageConfiguration(
      context,
    );
    for (final String url in imageUrls) {
      if (!_retainedImages.containsKey(url)) {
        final ImageStream stream = PersistentNetworkImage(
          url,
        ).resolve(configuration);
        final ImageStreamListener listener = ImageStreamListener(
          (ImageInfo imageInfo, bool synchronousCall) => imageInfo.dispose(),
          onError: (Object exception, StackTrace? stackTrace) {
            debugPrint('Could not preload a product image: $exception');
            if (stackTrace != null) {
              debugPrintStack(stackTrace: stackTrace);
            }
          },
        );
        stream.addListener(listener);
        _retainedImages[url] = (stream, listener);
      }
    }
  }
}
