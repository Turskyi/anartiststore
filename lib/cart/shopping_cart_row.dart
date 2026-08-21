import 'package:anartiststore/model/app_state_model.dart';
import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class ShoppingCartRow extends StatelessWidget {
  const ShoppingCartRow({
    required this.product,
    required this.quantity,
    this.onPressed,
    super.key,
  });

  final Product product;
  final int? quantity;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData localTheme = Theme.of(context);

    return ScopedModelDescendant<AppStateModel>(
      builder: (BuildContext context, Widget? child, AppStateModel model) {
        final NumberFormat formatter = NumberFormat.currency(
          symbol: '${model.selectedCurrency.symbol} ',
          decimalDigits: 2,
        );
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
                  args: <String, String>{constants.productKey: product.name},
                ),
                button: true,
                enabled: true,
                child: ExcludeSemantics(
                  child: SizedBox(
                    width: constants.startColumnWidth,
                    child: IconButton(
                      icon: const Icon(Icons.close),
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
                            loadingBuilder:
                                (
                                  _,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress,
                                ) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    final int? expectedTotalBytes =
                                        loadingProgress.expectedTotalBytes;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: expectedTotalBytes != null
                                            ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  expectedTotalBytes
                                            : null,
                                      ),
                                    );
                                  }
                                },
                            errorBuilder:
                                (BuildContext _, Object _, StackTrace? _) {
                                  return Text(translate('error_loading_image'));
                                },
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
                                            product.name,
                                            style:
                                                (localTheme
                                                            .textTheme
                                                            .titleMedium ??
                                                        const TextStyle())
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                          ),
                                        ),
                                        SelectableText(
                                          formatter.format(
                                            model.getConvertedPrice(
                                              product.priceInCents,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
