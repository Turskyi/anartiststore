import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/res/values/colors.dart';
import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

class ShoppingCartRow extends StatelessWidget {
  const ShoppingCartRow({
    super.key,
    required this.product,
    required this.quantity,
    this.onPressed,
  });

  final Product product;
  final int? quantity;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: 2,
      locale: Localizations.localeOf(context).toString(),
    );
    final ThemeData localTheme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        key: ValueKey<String>(product.id),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Semantics(
            container: true,
            label: translate(
              'anArtistStoreScreenReaderRemoveProductButton',
              args: <String, String>{'product': product.name},
            ),
            button: true,
            enabled: true,
            child: ExcludeSemantics(
              child: SizedBox(
                width: constants.startColumnWidth,
                child: IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: onPressed,
                  tooltip: translate('anArtistStoreTooltipRemoveItem'),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 16),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        width: 75,
                        height: 75,
                        excludeFromSemantics: true,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: MergeSemantics(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              MergeSemantics(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: SelectableText(
                                        translate(
                                          'anArtistStoreProductQuantity',
                                          args: <String, int>{
                                            'quantity': quantity!,
                                          },
                                        ),
                                      ),
                                    ),
                                    SelectableText(
                                      translate(
                                        'anArtistStoreProductPrice',
                                        args: <String, String>{
                                          'price':
                                              formatter.format(product.price),
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SelectableText(
                                product.name,
                                style: localTheme.textTheme.titleMedium!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(
                    color: kAnArtistStoreGreen900,
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
