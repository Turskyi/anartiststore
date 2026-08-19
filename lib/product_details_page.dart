import 'package:anartiststore/enums/product_availability.dart';
import 'package:anartiststore/model/app_state_model.dart';
import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:anartiststore/ui/favourite_button.dart';
import 'package:anartiststore/ui/share_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({required this.product, super.key});

  final Product product;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final GlobalKey _imageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final AppStateModel model = ScopedModel.of<AppStateModel>(context);
    final NumberFormat formatter = NumberFormat.currency(
      symbol: '${model.selectedCurrency.symbol} ',
      decimalDigits: 2,
    );
    final ThemeData theme = Theme.of(context);
    final bool isWideScreen =
        MediaQuery.sizeOf(context).width > constants.kDesktopBreakpoint;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        elevation: 0,
        actions: <Widget>[
          ShareButton(product: widget.product),
          FavouriteButton(productId: widget.product.id),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: isWideScreen
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: _ProductImage(
                      product: widget.product,
                      imageKey: _imageKey,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 1,
                    child: _ProductDetails(
                      product: widget.product,
                      formatter: formatter,
                      theme: theme,
                      model: model,
                      onAddToCart: _onAddToCart,
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _ProductImage(
                    product: widget.product,
                    imageKey: _imageKey,
                  ),
                  const SizedBox(height: 24),
                  _ProductDetails(
                    product: widget.product,
                    formatter: formatter,
                    theme: theme,
                    model: model,
                    onAddToCart: _onAddToCart,
                  ),
                ],
              ),
      ),
    );
  }

  void _onAddToCart(AppStateModel model) {
    _runFlyAnimation();
    model.addProductToCart(widget.product.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(translate('productAdded')),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.sizeOf(context).height -
              (kToolbarHeight + kMinInteractiveDimension),
          right: 20,
          left: 20,
        ),
      ),
    );
  }

  void _runFlyAnimation() {
    final RenderObject? renderObject =
        _imageKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox) return;

    final Size size = renderObject.size;
    final Offset position = renderObject.localToGlobal(Offset.zero);
    final OverlayState overlay = Overlay.of(context);

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (BuildContext context) {
        return _FlyingImage(
          imageUrl: widget.product.imageUrl,
          startPosition: position,
          startSize: size,
          onComplete: () => entry.remove(),
        );
      },
    );

    overlay.insert(entry);
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({
    required this.product,
    required this.imageKey,
  });

  final Product product;
  final GlobalKey imageKey;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'product_image_${product.id}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          product.imageUrl,
          key: imageKey,
          fit: BoxFit.cover,
          loadingBuilder: (_, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            final int? totalBytes = loadingProgress.expectedTotalBytes;
            return Center(
              child: CircularProgressIndicator(
                value: totalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / totalBytes
                    : null,
              ),
            );
          },
          errorBuilder: (_, __, ___) => Center(
            child: Text(translate('error_loading_image')),
          ),
        ),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  const _ProductDetails({
    required this.product,
    required this.formatter,
    required this.theme,
    required this.model,
    required this.onAddToCart,
  });

  final Product product;
  final NumberFormat formatter;
  final ThemeData theme;
  final AppStateModel model;
  final void Function(AppStateModel) onAddToCart;

  @override
  Widget build(BuildContext context) {
    final bool isAvailable =
        product.availability == ProductAvailability.available;
    final String? availabilityText = !isAvailable
        ? (product.availability == ProductAvailability.reserved
            ? translate('currentlyReserved')
            : translate('alreadySold'))
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Hero(
          tag: 'product_name_${product.id}',
          child: Text(
            product.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Hero(
              tag: 'product_price_${product.id}',
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  formatter
                      .format(model.getConvertedPrice(product.priceInCents)),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (availabilityText != null) ...<Widget>[
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  availabilityText,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 24),
        Text(
          product.description,
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: isAvailable ? () => onAddToCart(model) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              disabledBackgroundColor:
                  theme.colorScheme.onSurface.withValues(alpha: 0.12),
              disabledForegroundColor:
                  theme.colorScheme.onSurface.withValues(alpha: 0.38),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Text(
              isAvailable ? translate('addToCart') : (availabilityText ?? ''),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FlyingImage extends StatefulWidget {
  const _FlyingImage({
    required this.imageUrl,
    required this.startPosition,
    required this.startSize,
    required this.onComplete,
  });

  final String imageUrl;
  final Offset startPosition;
  final Size startSize;
  final VoidCallback onComplete;

  @override
  State<_FlyingImage> createState() => _FlyingImageState();
}

class _FlyingImageState extends State<_FlyingImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    );
    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    // Target position is near the bottom-right where the cart icon is.
    final Offset targetPosition = Offset(
      screenSize.width - 60,
      screenSize.height - 60,
    );

    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        final double t = _animation.value;
        final double x =
            Offset.lerp(widget.startPosition, targetPosition, t)?.dx ?? 0;
        final double y =
            Offset.lerp(widget.startPosition, targetPosition, t)?.dy ?? 0;
        final double scale = (1.0 - (t * 0.8)).clamp(0.0, 1.0);
        final double opacity = (1.0 - (t * 0.5)).clamp(0.0, 1.0);

        return Positioned(
          left: x,
          top: y,
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: widget.startSize.width,
                height: widget.startSize.height,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    (16 * (1 - t)).clamp(0.0, 16.0),
                  ),
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
