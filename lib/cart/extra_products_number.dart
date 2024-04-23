import 'package:anartiststore/model/app_state_model.dart';
import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ExtraProductsNumber extends StatelessWidget {
  const ExtraProductsNumber({super.key});

  // Calculates the number to be displayed at the end of the row if there are
  // more than three products in the cart. This calculates overflow products,
  // including their duplicates (but not duplicates of products shown as
  // thumbnails).
  int _calculateOverflow(AppStateModel model) {
    final Map<String, int> productMap = model.productsInCart;
    // List created to be able to access products by index instead of ID.
    // Order is guaranteed because productsInCart returns a LinkedHashMap.
    final List<String> products = productMap.keys.toList();
    int overflow = 0;
    final int numProducts = products.length;
    for (int i = constants.maxThumbnailCount; i < numProducts; i++) {
      overflow += productMap[products[i]]!;
    }
    return overflow;
  }

  Widget _buildOverflow(AppStateModel model, BuildContext context) {
    if (model.productsInCart.length <= constants.maxThumbnailCount) {
      return Container();
    }

    final int numOverflowProducts = _calculateOverflow(model);
    // Maximum of 99 so padding doesn't get messy.
    final int displayedOverflowProducts =
        numOverflowProducts <= 99 ? numOverflowProducts : 99;
    return Text(
      '+$displayedOverflowProducts',
      style: Theme.of(context).primaryTextTheme.labelLarge,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
      builder: (BuildContext builder, Widget? child, AppStateModel model) =>
          _buildOverflow(model, context),
    );
  }
}
