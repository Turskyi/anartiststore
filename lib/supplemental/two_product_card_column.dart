import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/supplemental/product_card.dart';
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

        double heightOfCards =
            (constraints.biggest.height - spacerHeight) / 2.0;
        double heightOfImages = heightOfCards - ProductCard.kTextBoxHeight;
        double imageAspectRatio = heightOfImages >= 0.0
            ? constraints.biggest.width / heightOfImages
            : 49.0 / 33.0;

        return ListView(
          physics: const ClampingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 28.0),
              child: top != null
                  ? ProductCard(
                imageAspectRatio: imageAspectRatio,
                product: top!,
              )
                  : SizedBox(
                height: heightOfCards,
              ),
            ),
            const SizedBox(height: spacerHeight),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 28.0),
              child: ProductCard(
                imageAspectRatio: imageAspectRatio,
                product: bottom,
              ),
            ),
          ],
        );
      },
    );
  }
}