import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/supplemental/mobile_product_card.dart';
import 'package:flutter/material.dart';

class ProductGridView extends StatelessWidget {
  const ProductGridView({
    required this.products,
    super.key,
  });

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Adapt rows based on height for better desktop/tablet experience
        final int crossAxisCount = constraints.maxHeight > 800 ? 3 : 2;

        const double spacing = 8.0;
        const EdgeInsets padding = EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 28.0);

        // Calculate the height available for one cell (cross axis)
        final double totalHeight = constraints.maxHeight;
        final double availableHeight = totalHeight -
            padding.top -
            padding.bottom -
            (spacing * (crossAxisCount - 1));
        final double cellHeight = availableHeight / crossAxisCount;

        // In MobileProductCard, we have:
        // Column(
        //   children: [
        //     Flexible(child: AspectRatio(1.0, ...)),
        //     SizedBox(height: kTextBoxHeight * textScale),
        //   ]
        // )
        // To keep images square, the image width must equal the image height.
        // Image height = cellHeight - textBoxHeight.
        final double textScale = MediaQuery.textScalerOf(context).scale(1);
        final double textBoxHeight =
            MobileProductCard.kTextBoxHeight * textScale;
        final double imageHeight = cellHeight - textBoxHeight;

        // The cell width (main axis extent) should be equal to the image height
        // to keep the image square 1:1.
        final double cellWidth = imageHeight > 0 ? imageHeight : cellHeight;

        // childAspectRatio for horizontal grid is crossAxisExtent / mainAxisExtent
        // which is height / width.
        final double childAspectRatio = cellHeight / cellWidth;

        return GridView.builder(
          scrollDirection: Axis.horizontal,
          padding: padding,
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (BuildContext context, int index) {
            return MobileProductCard(
              product: products[index],
              imageAspectRatio: 1.0, // Explicitly square
            );
          },
        );
      },
    );
  }
}
