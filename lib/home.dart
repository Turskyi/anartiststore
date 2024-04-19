import 'package:anartiststore/enums/group.dart';
import 'package:anartiststore/model/products_repository.dart';
import 'package:anartiststore/supplemental/asymmetric_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({this.category = Group.all, super.key});

  final Group category;

  @override
  Widget build(BuildContext context) {
    return AsymmetricView(products: ProductsRepository.loadProducts(category));
  }
}
