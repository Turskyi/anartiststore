import 'package:anartiststore/model/app_state_model.dart';
import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/router/app_route.dart';
import 'package:anartiststore/ui/favourite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class MobileProductCard extends StatelessWidget {
  const MobileProductCard({
    required this.product,
    this.imageAspectRatio = 1.0,
    super.key,
  }) : assert(imageAspectRatio > 0);

  final double imageAspectRatio;
  final Product product;

  static const double kTextBoxHeight = 65.0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ScopedModelDescendant<AppStateModel>(
      builder: (BuildContext context, Widget? child, AppStateModel model) {
        final NumberFormat formatter = NumberFormat.currency(
          symbol: '${model.selectedCurrency.symbol} ',
          decimalDigits: 2,
        );

        final Image imageWidget = Image.network(
          product.imageUrl,
          fit: BoxFit.contain,
          loadingBuilder: (_, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              final int? expectedTotalBytes =
                  loadingProgress.expectedTotalBytes;
              return Center(
                child: CircularProgressIndicator(
                  value: expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          expectedTotalBytes
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
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  // We need a finite width to allow the children to size
                  // themselves.
                  final double width = constraints.maxWidth.isFinite
                      ? constraints.maxWidth
                      : 150.0;

                  return FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SizedBox(
                      width: width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: imageAspectRatio,
                            child: Stack(
                              children: <Widget>[
                                Hero(
                                  tag: 'product_image_${product.id}',
                                  child: imageWidget,
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: FavouriteButton(productId: product.id),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: kTextBoxHeight *
                                MediaQuery.textScalerOf(context).scale(1),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Hero(
                                    tag: 'product_name_${product.id}',
                                    child: Text(
                                      product.name,
                                      style: theme.textTheme.labelLarge,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Hero(
                                    tag: 'product_price_${product.id}',
                                    child: Text(
                                      formatter.format(
                                        model.getConvertedPrice(
                                          product.priceInCents,
                                        ),
                                      ),
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _navigateToProductDetails(BuildContext context) {
    return Navigator.of(context).pushNamed(
      AppRoute.productDetails.path,
      arguments: product,
    );
  }
}
