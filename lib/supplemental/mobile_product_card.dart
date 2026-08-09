import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/router/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

class MobileProductCard extends StatelessWidget {
  const MobileProductCard({
    this.imageAspectRatio = 33 / 49,
    required this.product,
    super.key,
  }) : assert(imageAspectRatio > 0);

  final double imageAspectRatio;
  final Product product;

  static const double kTextBoxHeight = 65.0;

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: 2,
      locale: Localizations.localeOf(context).toString(),
    );
    final ThemeData theme = Theme.of(context);

    final Image imageWidget = Image.network(
      product.imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (_, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        }
      },
      errorBuilder: (_, __, ___) {
        return Text(translate('error_loading_image'));
      },
    );

    return Semantics(
      hint: translate('viewDetails'),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            _navigateToProductDetails(context);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AspectRatio(
                aspectRatio: imageAspectRatio,
                child: Hero(
                  tag: 'product_image_${product.id}',
                  child: imageWidget,
                ),
              ),
              SizedBox(
                height:
                    kTextBoxHeight * MediaQuery.textScalerOf(context).scale(1),
                width: 121.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: theme.textTheme.labelLarge,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      formatter.format(product.price),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToProductDetails(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoute.productDetails.path,
      arguments: product,
    );
  }
}
