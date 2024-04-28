import 'package:anartiststore/cart/confirmation_dialog.dart';
import 'package:anartiststore/cart/expanding_bottom_sheet.dart';
import 'package:anartiststore/cart/shopping_cart_row.dart';
import 'package:anartiststore/cart/shopping_cart_summary.dart';
import 'package:anartiststore/layout/letter_spacing.dart';
import 'package:anartiststore/model/app_state_model.dart';
import 'package:anartiststore/model/contact_info.dart';
import 'package:anartiststore/res/values/colors.dart';
import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:anartiststore/theme.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:scoped_model/scoped_model.dart';

const String _ordinalSortKeyName = 'shopping_cart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _emailValidNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _checkoutEnabledNotifier =
      ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    final ThemeData localTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: kAnArtistStoreBlue50,
      body: SafeArea(
        child: ScopedModelDescendant<AppStateModel>(
          builder: (
            BuildContext context,
            _,
            AppStateModel model,
          ) {
            final ExpandingBottomSheetState expandingBottomSheetState =
                ExpandingBottomSheet.of(context);
            return Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    Semantics(
                      sortKey:
                          const OrdinalSortKey(0, name: _ordinalSortKeyName),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: constants.startColumnWidth,
                            child: IconButton(
                              icon: const Icon(Icons.keyboard_arrow_down),
                              onPressed: () =>
                                  expandingBottomSheetState.close(),
                              tooltip: translate(
                                'anArtistStoreTooltipCloseCart',
                              ),
                            ),
                          ),
                          Text(
                            translate('anArtistStoreCartPageCaption'),
                            style: localTheme.textTheme.titleMedium!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            translatePlural(
                              'anArtistStoreCartItemCount',
                              model.totalCartQuantity,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Semantics(
                      sortKey:
                          const OrdinalSortKey(1, name: _ordinalSortKeyName),
                      child: Column(
                        children: _createShoppingCartRows(model),
                      ),
                    ),
                    Semantics(
                      sortKey:
                          const OrdinalSortKey(2, name: _ordinalSortKeyName),
                      child: ShoppingCartSummary(model: model),
                    ),
                    const SizedBox(height: 16), // Add some spacing
                    const Divider(),
                    if (model.productsInCart.isNotEmpty)
                      // Delivery Information
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                translate('deliveryInformation'),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ValueListenableBuilder<bool>(
                                valueListenable: _emailValidNotifier,
                                builder: (_, bool isValid, __) {
                                  return TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(
                                        constants.emailMaxLength,
                                      ),
                                    ],
                                    decoration: InputDecoration(
                                      labelText: translate('email'),
                                      errorText: isValid
                                          ? null
                                          : translate('enterValidEmail'),
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return translate('emailIsRequired');
                                      }
                                      return null;
                                    },
                                    onChanged: _validateEmail,
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _firstNameController,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  labelText: translate('firstName'),
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return translate('firstNameRequired');
                                  }
                                  return null;
                                },
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                    RegExp(
                                      constants
                                          .ukrainianEnglishGermanPolishPattern,
                                    ),
                                  ),
                                  LengthLimitingTextInputFormatter(
                                    constants.nameMaxLength,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                  labelText: translate('lastName'),
                                ),
                                keyboardType: TextInputType.name,
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(
                                    constants.nameMaxLength,
                                  ),
                                  FilteringTextInputFormatter.allow(
                                    RegExp(
                                      constants
                                          .ukrainianEnglishGermanPolishPattern,
                                    ),
                                  ),
                                ],
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return translate('lastNameRequired');
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _phoneNumberController,
                                decoration: InputDecoration(
                                  labelText: translate('phoneNumber'),
                                ),
                                keyboardType: TextInputType.phone,
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(
                                    constants.phoneMaxLength,
                                  ),
                                  FilteringTextInputFormatter.allow(
                                    RegExp(constants.phonePattern),
                                  ),
                                ],
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return translate('phoneNumberRequired');
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _streetController,
                                keyboardType: TextInputType.streetAddress,
                                decoration: InputDecoration(
                                  labelText: translate('streetAddress'),
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return translate('streetRequired');
                                  }
                                  return null;
                                },
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(
                                    constants.addressMaxLength,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _cityController,
                                keyboardType: TextInputType.streetAddress,
                                decoration: InputDecoration(
                                  labelText: translate('city'),
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return translate('cityRequired');
                                  }
                                  return null;
                                },
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(
                                    constants.addressMaxLength,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _postalCodeController,
                                decoration: InputDecoration(
                                  labelText: translate('postalCode'),
                                ),
                                keyboardType: TextInputType.streetAddress,
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(
                                    constants.postcodeMaxLength,
                                  ),
                                ],
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return translate('postalCodeRequired');
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _countryController,
                                keyboardType: TextInputType.streetAddress,
                                decoration: InputDecoration(
                                  labelText: translate('country'),
                                ),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return translate('countryRequired');
                                  }
                                  return null;
                                },
                                inputFormatters: <TextInputFormatter>[
                                  LengthLimitingTextInputFormatter(
                                    constants.addressMaxLength,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 100),
                  ],
                ),
                if (model.productsInCart.isNotEmpty)
                  PositionedDirectional(
                    bottom: 16,
                    start: 16,
                    end: 16,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Semantics(
                            sortKey: const OrdinalSortKey(
                              3,
                              name: _ordinalSortKeyName,
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const BeveledRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7)),
                                ),
                                backgroundColor: kAnArtistStoreBlue100,
                              ),
                              onPressed: () => _onClearCartPressed(
                                model,
                                expandingBottomSheetState,
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  translate(
                                    'anArtistStoreCartClearButtonCaption',
                                  ),
                                  style: TextStyle(
                                    letterSpacing: letterSpacingOrNone(
                                      largeLetterSpacing,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Semantics(
                            sortKey: const OrdinalSortKey(
                              3,
                              name: _ordinalSortKeyName,
                            ),
                            child: ValueListenableBuilder<bool>(
                              valueListenable: _checkoutEnabledNotifier,
                              builder: (
                                BuildContext context,
                                bool isEnabled,
                                Widget? child,
                              ) =>
                                  ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const BeveledRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(7),
                                    ),
                                  ),
                                  backgroundColor: kAnArtistStoreBlue100,
                                ),
                                onPressed: isEnabled
                                    ? () => _onCheckoutPressed(
                                          model: model,
                                          expandingBottomSheetState:
                                              expandingBottomSheetState,
                                        )
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: isEnabled
                                      ? Text(
                                          translate('checkout'),
                                          style: TextStyle(
                                            letterSpacing: letterSpacingOrNone(
                                              largeLetterSpacing,
                                            ),
                                          ),
                                        )
                                      : const CircularProgressIndicator(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  List<Widget> _createShoppingCartRows(AppStateModel model) {
    return model.productsInCart.keys
        .map(
          (String id) => ShoppingCartRow(
            product: model.getProductById(id),
            quantity: model.productsInCart[id],
            onPressed: () {
              model.removeItemFromCart(id);
            },
          ),
        )
        .toList();
  }

  void _onClearCartPressed(
    AppStateModel model,
    ExpandingBottomSheetState expandingBottomSheet,
  ) {
    model.clearCart();
    expandingBottomSheet.close();
  }

  void _validateEmail(String value) {
    _emailValidNotifier.value = EmailValidator.validate(value);
  }

  Future<void> _onCheckoutPressed({
    required AppStateModel model,
    required ExpandingBottomSheetState expandingBottomSheetState,
  }) async {
    if (_formKey.currentState?.validate() ?? false) {
      await model.checkout(
        ContactInfo(
          email: _emailController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          phoneNumber: _phoneNumberController.text,
          street: _streetController.text,
          city: _cityController.text,
          postalCode: _postalCodeController.text,
          country: _countryController.text,
        ),
      );
      _onClearCartPressed(model, expandingBottomSheetState);
      if (mounted) {
        await showDialog(
          context: context,
          builder: (_) => const ConfirmationDialog(),
        );
      }
    }
  }
}
