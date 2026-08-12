import 'package:anartiststore/model/app_state_model.dart';
import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/ui/favourite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: 2,
      locale: Localizations.localeOf(context).toString(),
    );
    final ThemeData theme = Theme.of(context);
    final bool isWideScreen = MediaQuery.sizeOf(context).width > 800;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        elevation: 0,
        actions: <Widget>[
          FavouriteButton(productId: product.id),
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
                    child: _ProductImage(product: product),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 1,
                    child: _ProductDetails(
                      product: product,
                      formatter: formatter,
                      theme: theme,
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _ProductImage(product: product),
                  const SizedBox(height: 24),
                  _ProductDetails(
                    product: product,
                    formatter: formatter,
                    theme: theme,
                  ),
                ],
              ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'product_image_${product.id}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          product.imageUrl,
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
  });

  final Product product;
  final NumberFormat formatter;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
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
        Hero(
          tag: 'product_price_${product.id}',
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              formatter.format(product.price),
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          product.description,
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 40),
        ScopedModelDescendant<AppStateModel>(
          builder: (BuildContext context, Widget? child, AppStateModel model) {
            return SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  _addToCart(model: model, context: context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  translate('addToCart'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _addToCart({
    required AppStateModel model,
    required BuildContext context,
  }) {
    model.addProductToCart(product.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(translate('productAdded')),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}
