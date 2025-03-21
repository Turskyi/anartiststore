import 'dart:math';

import 'package:anartiststore/backdrop/backdrop_title.dart';
import 'package:anartiststore/backdrop/front_layer.dart';
import 'package:anartiststore/bloc/products_bloc.dart';
import 'package:anartiststore/enums/group.dart';
import 'package:anartiststore/model/app_state_model.dart';
import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/settings/info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

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
    return Scaffold(
      appBar: AppBar(
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
            viewLeading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                _searchController.text = '';
                context.read<ProductsBloc>().add(const ClearEvent());
                Navigator.of(context).pop();
              },
            ),
            viewBackgroundColor:
                Theme.of(context).searchViewTheme.backgroundColor,
            searchController: _searchController,
            builder: (_, SearchController controller) {
              return IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  _searchController.text = '';
                  controller.openView();
                },
              );
            },
            suggestionsBuilder: (_, SearchController controller) {
              context.read<ProductsBloc>().add(SearchEvent(controller.text));
              return _buildGridCards();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.info_outline,
              semanticLabel: translate('info'),
            ),
            onPressed: () => Navigator.push(
              context,
              PageRouteBuilder<Widget>(
                pageBuilder: (
                  BuildContext context,
                  Animation<double> animation1,
                  Animation<double> animation2,
                ) =>
                    const InfoPage(),
                transitionDuration: const Duration(seconds: 1),
                transitionsBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> animationTime,
                  Widget child,
                ) {
                  animation = CurvedAnimation(
                    parent: animation,
                    curve: Curves.elasticInOut,
                  );
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: const Offset(0.0, 0.0),
                    ).animate(animation),
                    child: child,
                  );
                },
              ),
            ),
          ),
        ],
      ),
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
      return <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            const Icon(
              Icons.search_off_outlined,
              size: 150,
            ),
            const SizedBox(height: 20),
            Text(
              translate(
                'noResultsFoundFor',
                args: <String, String>{'query': _searchController.text},
              ),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ];
    }

    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: 2,
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
            child: ScopedModelDescendant<AppStateModel>(
              builder:
                  (BuildContext context, Widget? child, AppStateModel model) {
                return Semantics(
                  hint: translate('anArtistStoreScreenReaderProductAddToCart'),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        model.addProductToCart(product.id);
                        _searchController.text = '';
                        Navigator.of(context).pop();
                        // Show a brief notification (snackbar) at the top of
                        // the screen.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(translate('productAdded')),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            margin: EdgeInsets.only(
                              bottom: 40,
                              right: 20,
                              left: 20,
                            ),
                          ),
                        );
                      },
                      child: child,
                    ),
                  ),
                );
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 18 / 11,
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.fitWidth,
                            loadingBuilder: (
                              _,
                              Widget child,
                              ImageChunkEvent? loadingProgress,
                            ) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              }
                            },
                            errorBuilder: (_, __, ___) {
                              return Text(translate('error_loading_image'));
                            },
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
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
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withValues(alpha: 0.6),
                        child: const Icon(Icons.add_shopping_cart),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}
