import 'package:anartiststore/enums/group.dart';
import 'package:anartiststore/model/cart.dart';
import 'package:anartiststore/model/cart_item.dart';
import 'package:anartiststore/model/contact_info.dart';
import 'package:anartiststore/model/email_repository.dart';
import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/model/products_repository.dart';
import 'package:collection/collection.dart';
import 'package:scoped_model/scoped_model.dart';

double _salesTaxRate = 0.06;
double _shippingCostPerItem = 7;

class AppStateModel extends Model {
  AppStateModel(this._productsRepository, this._emailRepository);

  final ProductsRepository _productsRepository;
  final EmailRepository _emailRepository;

  // All the available products.
  List<Product> _availableProducts = <Product>[];

  // The currently selected category of products.
  Group _selectedCategory = groupAll;

  // The IDs and quantities of products currently in the cart.
  final Map<String, int> _productsInCart = <String, int>{};

  Map<String, int> get productsInCart => Map<String, int>.from(_productsInCart);

  // Total number of items in the cart.
  int get totalCartQuantity =>
      _productsInCart.values.fold(0, (int v, int e) => v + e);

  Group get selectedCategory => _selectedCategory;

  // Totaled prices of the items in the cart.
  double get subtotalCost {
    return _productsInCart.keys
        .map(
          (String id) =>
              _availableProducts
                  .firstWhereOrNull((Product product) => product.id == id)!
                  .price *
              _productsInCart[id]!,
        )
        .fold(0.0, (double sum, double e) => sum + e);
  }

  // Total shipping cost for the items in the cart.
  double get shippingCost {
    return _shippingCostPerItem *
        _productsInCart.values.fold(0.0, (num sum, int e) => sum + e);
  }

  // Sales tax for the items in the cart
  double get tax => subtotalCost * _salesTaxRate;

  // Total cost to order everything in the cart.
  double get totalCost => subtotalCost + shippingCost + tax;

  // Returns a copy of the list of available products, filtered by category.
  List<Product> getProducts() {
    if (_selectedCategory == groupAll) {
      return List<Product>.from(_availableProducts);
    } else {
      return _availableProducts
          .where(
            (Product product) =>
                product.description.contains(_selectedCategory.name),
          )
          .toList();
    }
  }

  // Adds a product to the cart.
  void addProductToCart(String productId) {
    if (!_productsInCart.containsKey(productId)) {
      _productsInCart[productId] = 1;
    } else {
      _productsInCart[productId] = _productsInCart[productId]! + 1;
    }

    notifyListeners();
  }

  // Adds products to the cart by a certain amount.
  // quantity must be non-null positive value.
  void addMultipleProductsToCart(String productId, int quantity) {
    assert(quantity > 0);
    if (!_productsInCart.containsKey(productId)) {
      _productsInCart[productId] = quantity;
    } else {
      _productsInCart[productId] = _productsInCart[productId]! + quantity;
    }

    notifyListeners();
  }

  // Removes an item from the cart.
  void removeItemFromCart(String productId) {
    if (_productsInCart.containsKey(productId)) {
      if (_productsInCart[productId] == 1) {
        _productsInCart.remove(productId);
      } else {
        _productsInCart[productId] = _productsInCart[productId]! - 1;
      }
    }

    notifyListeners();
  }

  // Returns the Product instance matching the provided id.
  Product getProductById(String id) {
    return _availableProducts.firstWhere((Product p) => p.id == id);
  }

  // Removes everything from the cart.
  void clearCart() {
    _productsInCart.clear();
    notifyListeners();
  }

  // Loads the list of available products from the repo.
  Future<void> loadProducts() async {
    _availableProducts = await _productsRepository.loadProducts(groupAll);
    notifyListeners();
  }

  void setCategory(Group newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();
  }

  List<CartItem> _convertProductsInCartToCartItems() {
    final List<CartItem> cartItems = <CartItem>[];
    _productsInCart.forEach((String productId, int quantity) {
      final Product product = getProductById(productId);
      cartItems
          .add(CartItem(id: productId, product: product, quantity: quantity));
    });
    return cartItems;
  }

  Future<void> checkout(ContactInfo contactInfo) {
    final List<CartItem> cartItems = _convertProductsInCartToCartItems();
    return _emailRepository.sendOrderEmail(
      cart: Cart(
        tax: tax,
        shippingCost: shippingCost,
        subtotalCost: subtotalCost,
        totalCost: totalCost,
        items: cartItems,
      ),
      contactInfo: contactInfo,
    );
  }
}
