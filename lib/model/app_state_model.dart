import 'package:anartiststore/data/remote/currency_service.dart';
import 'package:anartiststore/enums/currency.dart';
import 'package:anartiststore/enums/group.dart';
import 'package:anartiststore/model/cart.dart';
import 'package:anartiststore/model/cart_item.dart';
import 'package:anartiststore/model/cart_repository.dart';
import 'package:anartiststore/model/contact_info.dart';
import 'package:anartiststore/model/currency_repository.dart';
import 'package:anartiststore/model/email_repository.dart';
import 'package:anartiststore/model/product.dart';
import 'package:anartiststore/model/products_repository.dart';
import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:collection/collection.dart';
import 'package:scoped_model/scoped_model.dart';

class AppStateModel extends Model {
  AppStateModel(
    this._productsRepository,
    this._emailRepository,
    this._currencyRepository,
    this._currencyService,
    this._cartRepository,
  );

  final ProductsRepository _productsRepository;
  final EmailRepository _emailRepository;
  final CurrencyRepository _currencyRepository;
  final CurrencyService _currencyService;
  final CartRepository _cartRepository;

  // All the available products.
  List<Product> _availableProducts = <Product>[];

  // The currently selected category of products.
  Group _selectedCategory = groupAll;

  // The currently selected currency.
  Currency _selectedCurrency = Currency.eur;

  // Exchange rates with EUR as base.
  Map<Currency, double> _exchangeRates = <Currency, double>{Currency.eur: 1.0};

  Currency get selectedCurrency => _selectedCurrency;

  // The IDs and quantities of products currently in the cart.
  final Map<String, int> _productsInCart = <String, int>{};

  Map<String, int> get productsInCart => Map<String, int>.from(_productsInCart);

  // Total number of items in the cart.
  int get totalCartQuantity =>
      _productsInCart.values.fold(0, (int v, int e) => v + e);

  Group get selectedCategory => _selectedCategory;

  // Totaled prices of the items in the cart.
  double get subtotalCost {
    final double subtotalInEur = _productsInCart.keys.map((String id) {
      final Product? product = _availableProducts
          .firstWhereOrNull((Product product) => product.id == id);
      final int? quantity = _productsInCart[id];

      if (product != null && quantity != null) {
        return product.price * quantity;
      }
      return 0.0;
    }).fold(0.0, (double sum, double e) => sum + e);

    return subtotalInEur * (_exchangeRates[_selectedCurrency] ?? 1.0);
  }

  // Total shipping cost for the items in the cart.
  double get shippingCost {
    final double shippingInEur = constants.shippingCostPerItem *
        _productsInCart.values.fold(0.0, (num sum, int e) => sum + e);
    return shippingInEur * (_exchangeRates[_selectedCurrency] ?? 1.0);
  }

  // Sales tax for the items in the cart
  double get tax => subtotalCost * constants.salesTaxRate;

  // Total cost to order everything in the cart.
  double get totalCost => subtotalCost + shippingCost + tax;

  double getConvertedPrice(int priceInEurCents) {
    final double priceInEur = priceInEurCents / 100;
    return priceInEur * (_exchangeRates[_selectedCurrency] ?? 1.0);
  }

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
    final int? currentQuantity = _productsInCart[productId];
    if (currentQuantity == null) {
      _productsInCart[productId] = 1;
    } else {
      _productsInCart[productId] = currentQuantity + 1;
    }

    _cartRepository.saveCart(_productsInCart);
    notifyListeners();
  }

  // Adds products to the cart by a certain amount.
  // quantity must be non-null positive value.
  void addMultipleProductsToCart(String productId, int quantity) {
    assert(quantity > 0);
    final int? currentQuantity = _productsInCart[productId];
    if (currentQuantity == null) {
      _productsInCart[productId] = quantity;
    } else {
      _productsInCart[productId] = currentQuantity + quantity;
    }

    _cartRepository.saveCart(_productsInCart);
    notifyListeners();
  }

  // Removes an item from the cart.
  void removeItemFromCart(String productId) {
    final int? currentQuantity = _productsInCart[productId];
    if (currentQuantity != null) {
      if (currentQuantity == 1) {
        _productsInCart.remove(productId);
      } else {
        _productsInCart[productId] = currentQuantity - 1;
      }
    }

    _cartRepository.saveCart(_productsInCart);
    notifyListeners();
  }

  // Returns the Product instance matching the provided id.
  Product? getProductById(String id) {
    return _availableProducts.firstWhereOrNull((Product p) => p.id == id);
  }

  // Removes everything from the cart.
  void clearCart() {
    _productsInCart.clear();
    _cartRepository.clearCart();
    notifyListeners();
  }

  // Loads the list of available products from the repo.
  Future<void> loadProducts() async {
    _availableProducts = await _productsRepository.loadProducts(groupAll);
    notifyListeners();
  }

  // Loads the cart from the repo.
  Future<void> loadCart() async {
    final Map<String, int> persistedCart = await _cartRepository.getCart();
    _productsInCart.clear();
    _productsInCart.addAll(persistedCart);
    notifyListeners();
  }

  void setCategory(Group newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();
  }

  Future<void> setCurrency(Currency newCurrency) async {
    _selectedCurrency = newCurrency;
    await _currencyRepository.saveSelectedCurrency(newCurrency);
    notifyListeners();
  }

  Future<void> loadCurrency() async {
    _selectedCurrency = await _currencyRepository.getSelectedCurrency();
    _exchangeRates = await _currencyService.fetchExchangeRates();
    notifyListeners();
  }

  List<CartItem> _convertProductsInCartToCartItems() {
    final List<CartItem> cartItems = <CartItem>[];
    _productsInCart.forEach((String productId, int quantity) {
      final Product? product = getProductById(productId);
      if (product != null) {
        cartItems.add(
          CartItem(
            id: productId,
            product: product,
            quantity: quantity,
            convertedPrice: getConvertedPrice(product.priceInCents),
          ),
        );
      }
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
      currencyCode: _selectedCurrency.code,
    );
  }
}
