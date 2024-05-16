import 'dart:math';

import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/supplemental/mobile_product_card.dart';
import 'package:flutter/material.dart';

class TwoProductCardColumn extends StatelessWidget {
  const TwoProductCardColumn({
    required this.bottom,
    this.top,
    super.key,
  });

  final Product bottom;
  final Product? top;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const double spacerHeight = 44.0;

        // Ensure the height of cards is not negative
        double heightOfCards = max(
          (constraints.biggest.height - spacerHeight) / 2.0,
          0.0,
        );
        double heightOfImages = max(
          heightOfCards - MobileProductCard.kTextBoxHeight,
          0.0,
        );
        double imageAspectRatio = heightOfImages > 0.0
            ? constraints.biggest.width / heightOfImages
            : 49.0 / 33.0;

        return ListView(
          physics: const ClampingScrollPhysics(),
          children: <Widget>[
            if (top != null)
              MobileProductCard(
                imageAspectRatio: imageAspectRatio,
                product: top!,
              ),
            if (top != null) const SizedBox(height: spacerHeight),
            MobileProductCard(
              imageAspectRatio: imageAspectRatio,
              product: bottom,
            ),
          ],
        );
      },
    );
  }
}
