import 'package:anartiststore/cart/thumbnail_height.dart';
import 'package:anartiststore/model/product.dart';
import 'package:flutter/material.dart';

class ProductThumbnail extends StatelessWidget {
  const ProductThumbnail(
    this.animation,
    this.opacityAnimation,
    this.product, {
    super.key,
  });

  final Animation<double> animation;
  final Animation<double> opacityAnimation;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: opacityAnimation,
      child: ScaleTransition(
        scale: animation,
        child: Container(
          width: thumbnailHeight(context),
          height: thumbnailHeight(context),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          margin: const EdgeInsetsDirectional.only(start: 16),
        ),
      ),
    );
  }
}
