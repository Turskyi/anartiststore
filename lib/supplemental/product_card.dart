import 'package:anartiststore/model/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
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
      decimalDigits: 0,
      locale: Localizations.localeOf(context).toString(),
    );
    final ThemeData theme = Theme.of(context);

    final Image imageWidget = Image.asset(
      product.assetName,
      fit: BoxFit.cover,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        AspectRatio(
          aspectRatio: imageAspectRatio,
          child: imageWidget,
        ),
        SizedBox(
          height: kTextBoxHeight * MediaQuery.textScalerOf(context).scale(1),
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
    );
  }
}
