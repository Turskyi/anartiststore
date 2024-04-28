import 'package:anartiststore/layout/letter_spacing.dart';
import 'package:anartiststore/model/app_state_model.dart';
import 'package:anartiststore/res/values/colors.dart';
import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:anartiststore/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

class ShoppingCartSummary extends StatelessWidget {
  const ShoppingCartSummary({
    super.key,
    required this.model,
  });

  final AppStateModel model;

  @override
  Widget build(BuildContext context) {
    final TextStyle smallAmountStyle = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(color: kAnArtistStoreGreen600);
    final TextStyle largeAmountStyle = Theme.of(context)
        .textTheme
        .headlineMedium!
        .copyWith(letterSpacing: letterSpacingOrNone(mediumLetterSpacing));
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: 2,
      locale: Localizations.localeOf(context).toString(),
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
                      SelectableText(translate('anArtistStoreCartTaxCaption')),
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
  }
}
