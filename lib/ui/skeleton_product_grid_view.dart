import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:anartiststore/ui/skeleton_product_card.dart';
import 'package:flutter/material.dart';

class SkeletonProductGridView extends StatelessWidget {
  const SkeletonProductGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int crossAxisCount =
            constraints.maxHeight > constants.kDesktopBreakpoint ? 3 : 2;

        const double spacing = 8.0;
        const EdgeInsets padding = EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 28.0);

        final double totalHeight = constraints.maxHeight;
        final double availableHeight =
            totalHeight -
            padding.top -
            padding.bottom -
            (spacing * (crossAxisCount - 1));
        final double cellHeight = availableHeight / crossAxisCount;

        final double textScale = MediaQuery.textScalerOf(context).scale(1);
        const double kTextBoxHeight = 65.0;
        final double textBoxHeight = kTextBoxHeight * textScale;
        final double imageHeight = cellHeight - textBoxHeight;

        final double cellWidth = imageHeight > 0 ? imageHeight : cellHeight;
        final double childAspectRatio = cellHeight / cellWidth;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: padding,
          itemCount: 10, // Show a fixed number of skeleton items
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (BuildContext context, int index) {
            return const SkeletonProductCard(imageAspectRatio: 1.0);
          },
        );
      },
    );
  }
}
