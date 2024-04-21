import 'dart:math';

import 'package:anartiststore/backdrop/backdrop_title.dart';
import 'package:anartiststore/backdrop/front_layer.dart';
import 'package:anartiststore/bloc/products_bloc.dart';
import 'package:anartiststore/enums/group.dart';
import 'package:anartiststore/login.dart';
import 'package:anartiststore/model/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

const double _kFlingVelocity = 2.0;

/// Builds a Backdrop.
///
/// A Backdrop widget has two layers, front and back. The front layer is shown
/// by default, and slides down to show the back layer, from which a user
/// can make a selection. The user can also configure the titles for when the
/// front or back layer is showing.
class Backdrop extends StatefulWidget {
  const Backdrop({
    required this.currentCategory,
    required this.frontLayer,
    required this.backLayer,
    required this.frontTitle,
    required this.backTitle,
    this.products = const <Product>[],
    super.key,
  });

  final Group currentCategory;
  final Widget frontLayer;
  final Widget backLayer;
  final Widget frontTitle;
  final Widget backTitle;
  final List<Product> products;

  @override
  State<Backdrop> createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  final SearchController _searchController = SearchController();
  late AnimationController _animationController;

  bool get _frontLayerVisible {
    final AnimationStatus status = _animationController.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(Backdrop old) {
    super.didUpdateWidget(old);
    if (widget.currentCategory != old.currentCategory) {
      _toggleBackdropLayerVisibility();
    } else if (!_frontLayerVisible) {
      _animationController.fling(velocity: _kFlingVelocity);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      elevation: 0.0,
      titleSpacing: 0.0,
      title: BackdropTitle(
        listenable: _animationController.view,
        onMenuPressed: _toggleBackdropLayerVisibility,
        frontTitle: widget.frontTitle,
        backTitle: widget.backTitle,
      ),
      actions: <Widget>[
        SearchAnchor(
          viewBackgroundColor:
              Theme.of(context).searchViewTheme.backgroundColor,
          searchController: _searchController,
          builder: (BuildContext context, SearchController controller) {
            return IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => controller.openView(),
            );
          },
          suggestionsBuilder: (_, SearchController controller) {
            context.read<ProductsBloc>().add(SearchEvent(controller.text));
            return _buildGridCards();
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.tune,
            semanticLabel: 'settings',
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const LoginPage(),
            ),
          ),
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(builder: _buildStack),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double layerTitleHeight = 48.0;
    final Size layerSize = constraints.biggest;
    final double layerTop = layerSize.height - layerTitleHeight;

    Animation<RelativeRect> layerAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
        0.0,
        layerTop,
        0.0,
        layerTop - layerSize.height,
      ),
      end: const RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(_animationController.view);

    return Stack(
      key: _backdropKey,
      children: <Widget>[
        ExcludeSemantics(
          excluding: _frontLayerVisible,
          child: widget.backLayer,
        ),
        PositionedTransition(
          rect: layerAnimation,
          child: FrontLayer(
            onTap: _toggleBackdropLayerVisibility,
            child: widget.frontLayer,
          ),
        ),
      ],
    );
  }

  void _toggleBackdropLayerVisibility() {
    _animationController.fling(
      velocity: _frontLayerVisible ? -_kFlingVelocity : _kFlingVelocity,
    );
  }

  List<Widget> _buildGridCards() {
    if (widget.products.isEmpty) {
      return const <Widget>[];
    }

    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toString(),
    );

    // Calculate the number of rows needed, each row containing two cards
    final int rowCount = (widget.products.length / 2).ceil();

    // Generate the rows of cards
    return List<Widget>.generate(rowCount, (int rowIndex) {
      // Get the index of the products for the start of this row
      final int startIndex = rowIndex * 2;
      // Get the products for this row (1 or 2 products)
      List<Product> productsForRow = widget.products.sublist(
        startIndex,
        min(startIndex + 2, widget.products.length),
      );

      // Create a row for the two products
      return Row(
        children: productsForRow.map((Product product) {
          return Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 18 / 11,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          product.name,
                          style: theme.textTheme.titleLarge,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          formatter.format(product.price),
                          style: theme.textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}
