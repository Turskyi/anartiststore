import 'package:anartiststore/layout/letter_spacing.dart';
import 'package:anartiststore/model/app_state_model.dart';
import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:anartiststore/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class ShoppingCartSummary extends StatelessWidget {
  const ShoppingCartSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle smallAmountStyle = theme.textTheme.bodyMedium!.copyWith(
      color: theme.colorScheme.onSecondaryContainer.withValues(alpha: 0.8),
    );
    final TextStyle largeAmountStyle = theme.textTheme.headlineMedium!.copyWith(
      letterSpacing: letterSpacingOrNone(mediumLetterSpacing),
    );

    return ScopedModelDescendant<AppStateModel>(
      builder: (BuildContext context, Widget? child, AppStateModel model) {
        final NumberFormat formatter = NumberFormat.currency(
          symbol: '${model.selectedCurrency.symbol} ',
          decimalDigits: 2,
        );

        return Row(
          children: <Widget>[
            const SizedBox(width: constants.startColumnWidth),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: Column(
                  children: <Widget>[
                    MergeSemantics(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SelectableText(
                            translate('anArtistStoreCartTotalCaption'),
                          ),
                          Expanded(
                            child: SelectableText(
                              formatter.format(model.totalCost),
                              style: largeAmountStyle,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    MergeSemantics(
                      child: Row(
                        children: <Widget>[
                          SelectableText(
                            translate('anArtistStoreCartSubtotalCaption'),
                          ),
                          Expanded(
                            child: SelectableText(
                              formatter.format(model.subtotalCost),
                              style: smallAmountStyle,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    MergeSemantics(
                      child: Row(
                        children: <Widget>[
                          SelectableText(
                            translate('anArtistStoreCartShippingCaption'),
                          ),
                          Expanded(
                            child: SelectableText(
                              formatter.format(model.shippingCost),
                              style: smallAmountStyle,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    MergeSemantics(
                      child: Row(
                        children: <Widget>[
                          SelectableText(
                            translate('anArtistStoreCartTaxCaption'),
                          ),
                          Expanded(
                            child: SelectableText(
                              formatter.format(model.tax),
                              style: smallAmountStyle,
                              textAlign: TextAlign.end,
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
        );
      },
    );
  }
}
