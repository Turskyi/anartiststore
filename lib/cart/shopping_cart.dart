import 'package:anartiststore/cart/expanding_bottom_sheet.dart';
import 'package:anartiststore/cart/shoping_cart_summary.dart';
import 'package:anartiststore/cart/shopping_cart_row.dart';
import 'package:anartiststore/layout/letter_spacing.dart';
import 'package:anartiststore/model/app_state_model.dart';
import 'package:anartiststore/res/values/colors.dart';
import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:anartiststore/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:scoped_model/scoped_model.dart';

const String _ordinalSortKeyName = 'shopping_cart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  List<Widget> _createShoppingCartRows(AppStateModel model) {
    return model.productsInCart.keys
        .map(
          (String id) => ShoppingCartRow(
            product: model.getProductById(id),
            quantity: model.productsInCart[id],
            onPressed: () {
              model.removeItemFromCart(id);
            },
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData localTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: kAnArtistStorePink50,
      body: SafeArea(
        child: ScopedModelDescendant<AppStateModel>(
          builder: (BuildContext context, Widget? child, AppStateModel model) {
            final ExpandingBottomSheetState? expandingBottomSheet =
                ExpandingBottomSheet.of(context);
            return Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    Semantics(
                      sortKey:
                          const OrdinalSortKey(0, name: _ordinalSortKeyName),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: constants.startColumnWidth,
                            child: IconButton(
                              icon: const Icon(Icons.keyboard_arrow_down),
                              onPressed: () => expandingBottomSheet!.close(),
                              tooltip:
                                  translate('anArtistStoreTooltipCloseCart'),
                            ),
                          ),
                          Text(
                            translate('anArtistStoreCartPageCaption'),
                            style: localTheme.textTheme.titleMedium!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            translatePlural(
                              'anArtistStoreCartItemCount',
                              model.totalCartQuantity,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Semantics(
                      sortKey:
                          const OrdinalSortKey(1, name: _ordinalSortKeyName),
                      child: Column(
                        children: _createShoppingCartRows(model),
                      ),
                    ),
                    Semantics(
                      sortKey:
                          const OrdinalSortKey(2, name: _ordinalSortKeyName),
                      child: ShoppingCartSummary(model: model),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
                PositionedDirectional(
                  bottom: 16,
                  start: 16,
                  end: 16,
                  child: Semantics(
                    sortKey: const OrdinalSortKey(3, name: _ordinalSortKeyName),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        backgroundColor: kAnArtistStorePink100,
                      ),
                      onPressed: () {
                        model.clearCart();
                        expandingBottomSheet!.close();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          translate('anArtistStoreCartClearButtonCaption'),
                          style: TextStyle(
                            letterSpacing:
                                letterSpacingOrNone(largeLetterSpacing),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
