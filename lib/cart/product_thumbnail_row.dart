import 'package:anartiststore/cart/product_thumbnail.dart';
import 'package:anartiststore/model/app_state_model.dart';
import 'package:anartiststore/model/product.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductThumbnailRow extends StatefulWidget {
  const ProductThumbnailRow({super.key});

  @override
  State<ProductThumbnailRow> createState() => _ProductThumbnailRowState();
}

class _ProductThumbnailRowState extends State<ProductThumbnailRow> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  // _list represents what's currently on screen. If _internalList updates,
  // it will need to be updated to match it.
  late _ListModel _list;

  // _internalList represents the list as it is updated by the AppStateModel.
  late List<String> _internalList;

  @override
  void initState() {
    super.initState();
    _list = _ListModel(
      listKey: _listKey,
      initialItems:
          ScopedModel.of<AppStateModel>(context).productsInCart.keys.toList(),
      removedItemBuilder: _buildRemovedThumbnail,
    );
    _internalList = List<String>.from(_list.list);
  }

  Product _productWithId(String productId) {
    final AppStateModel model = ScopedModel.of<AppStateModel>(context);
    final Product product = model.getProductById(productId);
    return product;
  }

  Widget _buildRemovedThumbnail(
    String item,
    BuildContext context,
    Animation<double> animation,
  ) =>
      ProductThumbnail(animation, animation, _productWithId(item));

  Widget _buildThumbnail(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    final Animation<double> thumbnailSize =
        Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        curve: const Interval(0.33, 1, curve: Curves.easeIn),
        parent: animation,
      ),
    );

    final Animation<double> opacity = CurvedAnimation(
      curve: const Interval(0.33, 1, curve: Curves.linear),
      parent: animation,
    );

    return ProductThumbnail(
      thumbnailSize,
      opacity,
      _productWithId(_list[index]),
    );
  }

  // If the lists are the same length, assume nothing has changed.
  // If the internalList is shorter than the ListModel, an item has been
  // removed.
  // If the internalList is longer, then an item has been added.
  void _updateLists() {
    // Update _internalList based on the model
    _internalList =
        ScopedModel.of<AppStateModel>(context).productsInCart.keys.toList();
    final Set<String> internalSet = Set<String>.from(_internalList);
    final Set<String> listSet = Set<String>.from(_list.list);

    final Set<String> difference = internalSet.difference(listSet);
    if (difference.isEmpty) {
      return;
    }

    for (final String product in difference) {
      if (_internalList.length < _list.length) {
        _list.remove(product);
      } else if (_internalList.length > _list.length) {
        _list.add(product);
      }
    }

    while (_internalList.length != _list.length) {
      int index = 0;
      // Check bounds and that the list elements are the same
      while (_internalList.isNotEmpty &&
          _list.length > 0 &&
          index < _internalList.length &&
          index < _list.length &&
          _internalList[index] == _list[index]) {
        index++;
      }
    }
  }

  Widget _buildAnimatedList(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      shrinkWrap: true,
      itemBuilder: _buildThumbnail,
      initialItemCount: _list.length,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(), // Cart shouldn't scroll
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
      builder: (BuildContext context, Widget? child, AppStateModel model) {
        _updateLists();
        return _buildAnimatedList(context);
      },
    );
  }
}

// _ListModel manipulates an internal list and an AnimatedList
class _ListModel {
  _ListModel({
    required this.listKey,
    required this.removedItemBuilder,
    Iterable<String>? initialItems,
  }) : _items = initialItems?.toList() ?? <String>[];

  final GlobalKey<AnimatedListState> listKey;
  final Widget Function(String, BuildContext, Animation<double>)
      removedItemBuilder;
  final List<String> _items;

  AnimatedListState? get _animatedList => listKey.currentState;

  void add(String product) {
    _insert(_items.length, product);
  }

  void _insert(int index, String item) {
    _items.insert(index, item);
    _animatedList!
        .insertItem(index, duration: const Duration(milliseconds: 225));
  }

  void remove(String product) {
    final int index = _items.indexOf(product);
    if (index >= 0) {
      _removeAt(index);
    }
  }

  void _removeAt(int index) {
    final String removedItem = _items.removeAt(index);
    _animatedList!.removeItem(index,
        (BuildContext context, Animation<double> animation) {
      return removedItemBuilder(removedItem, context, animation);
    });
  }

  int get length => _items.length;

  String operator [](int index) => _items[index];

  int indexOf(String item) => _items.indexOf(item);

  List<String> get list => _items;
}
