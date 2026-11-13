import 'package:material_ui/material_ui.dart';
import 'package:shimmer/shimmer.dart';

class ProductImageLoadingPlaceholder extends StatelessWidget {
  const ProductImageLoadingPlaceholder({this.loadingProgress, super.key});

  final ImageChunkEvent? loadingProgress;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final int? expectedTotalBytes = loadingProgress?.expectedTotalBytes;
    final double? progress =
        expectedTotalBytes != null && expectedTotalBytes > 0
        ? (loadingProgress?.cumulativeBytesLoaded ?? 0) / expectedTotalBytes
        : null;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned.fill(
          child: Shimmer.fromColors(
            baseColor: colorScheme.surfaceContainerHighest,
            highlightColor: colorScheme.surface,
            child: ColoredBox(color: colorScheme.surfaceContainerHighest),
          ),
        ),
        Center(
          child: SizedBox(
            width: 52,
            height: 52,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  value: progress,
                  color: colorScheme.primary,
                ),
                if (progress != null)
                  Text(
                    '${(progress * 100).round()}%',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
