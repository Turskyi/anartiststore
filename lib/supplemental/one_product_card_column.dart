import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/supplemental/mobile_product_card.dart';
import 'package:flutter/material.dart';

class OneProductCardColumn extends StatelessWidget {
  const OneProductCardColumn({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints viewportConstraints) {
        // I use SingleChildScrollView instead of a Column to avoid
        // "A RenderFlex overflowed" issue.
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Padding(
              // Kind of center of the screen.
              padding: EdgeInsets.only(top: viewportConstraints.maxHeight / 5),
              child: MobileProductCard(product: product),
            ),
          ),
        );
      },
    );
  }
}
