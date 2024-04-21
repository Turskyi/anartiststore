import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/supplemental/product_card.dart';
import 'package:flutter/material.dart';

class OneProductCardColumn extends StatelessWidget {
  const OneProductCardColumn({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      reverse: true,
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 550,
          ),
          child: ProductCard(
            product: product,
          ),
        ),
        const SizedBox(
          height: 40.0,
        ),
      ],
    );
  }
}
