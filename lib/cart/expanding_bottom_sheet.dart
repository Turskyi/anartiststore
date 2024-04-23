import 'dart:math';

import 'package:anartiststore/cart/extra_products_number.dart';
import 'package:anartiststore/cart/product_thumbnail_row.dart';
import 'package:anartiststore/cart/shopping_cart.dart';
import 'package:anartiststore/cart/thumbnail_height.dart';
import 'package:anartiststore/layout/text_scale.dart';
import 'package:anartiststore/model/app_state_model.dart';
import 'package:anartiststore/page_status.dart';
import 'package:anartiststore/res/values/colors.dart';
import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:scoped_model/scoped_model.dart';

/// These curves define the emphasized easing curve.
const Cubic _accelerateCurve = Cubic(0.548, 0, 0.757, 0.464);
const Cubic _decelerateCurve = Cubic(0.23, 0.94, 0.41, 1);

/// The time at which the accelerate and decelerate curves switch off.
const double _peakVelocityTime = 0.248210;

/// Percent (as a decimal) of animation that should be completed at
/// [_peakVelocityTime].
const double _peakVelocityProgress = 0.379146;

/// Radius of the shape on the top start of the sheet for mobile layouts.
const double _mobileCornerRadius = 24.0;

/// Radius of the shape on the top start and bottom start of the sheet for
/// mobile layouts.
/// Width for just the cart icon and no thumbnails.
const double _cartIconWidth = 64.0;

/// Height for just the cart icon and no thumbnails.
const double _cartIconHeight = 56.0;

/// Gap between thumbnails.
const double _thumbnailGap = 16.0;

double _paddedThumbnailHeight(BuildContext context) {
  return thumbnailHeight(context) + _thumbnailGap;
}

class ExpandingBottomSheet extends StatefulWidget {
  const ExpandingBottomSheet({
    super.key,
    required this.hideController,
    required this.expandingController,
  });

  final AnimationController hideController;
  final AnimationController expandingController;

  @override
  ExpandingBottomSheetState createState() => ExpandingBottomSheetState();

  static ExpandingBottomSheetState? of(
    BuildContext context, {
    bool isNullOk = false,
  }) {
    final ExpandingBottomSheetState? result =
        context.findAncestorStateOfType<ExpandingBottomSheetState>();
    if (isNullOk || result != null) {
      return result;
    }
    throw FlutterError(
      'ExpandingBottomSheet.of() called with a context that does not contain a '
      'ExpandingBottomSheet.\n',
    );
  }
}

/// Emphasized Easing is a motion curve that has an organic, exciting feeling.
/// It's very fast to begin with and then very slow to finish. Unlike standard
/// curves, like [Curves.fastOutSlowIn], it can't be expressed in a cubic bezier
/// curve formula. It's quintic, not cubic. But it _can_ be expressed as one
/// curve followed by another, which we do here.
Animation<T> _getEmphasizedEasingAnimation<T>({
  required T begin,
  required T peak,
  required T end,
  required bool isForward,
  required Animation<double> parent,
}) {
  Curve firstCurve;
  Curve secondCurve;
  double firstWeight;
  double secondWeight;

  if (isForward) {
    firstCurve = _accelerateCurve;
    secondCurve = _decelerateCurve;
    firstWeight = _peakVelocityTime;
    secondWeight = 1 - _peakVelocityTime;
  } else {
    firstCurve = _decelerateCurve.flipped;
    secondCurve = _accelerateCurve.flipped;
    firstWeight = 1 - _peakVelocityTime;
    secondWeight = _peakVelocityTime;
  }

  return TweenSequence<T>(
    <TweenSequenceItem<T>>[
      TweenSequenceItem<T>(
        weight: firstWeight,
        tween: Tween<T>(
          begin: begin,
          end: peak,
        ).chain(CurveTween(curve: firstCurve)),
      ),
      TweenSequenceItem<T>(
        weight: secondWeight,
        tween: Tween<T>(
          begin: peak,
          end: end,
        ).chain(CurveTween(curve: secondCurve)),
      ),
    ],
  ).animate(parent);
}

/// Calculates the value where two double Animations should be joined. Used by
/// callers of _getEmphasisedEasing<double>().
double _getPeakPoint({required double begin, required double end}) {
  return begin + (end - begin) * _peakVelocityProgress;
}

class ExpandingBottomSheetState extends State<ExpandingBottomSheet> {
  final GlobalKey _expandingBottomSheetKey =
      GlobalKey(debugLabel: 'Expanding bottom sheet');

  // The width of the Material, calculated by _widthFor() & based on the number
  // of products in the cart. 64.0 is the width when there are 0 products
  // (_kWidthForZeroProducts)
  double _width = _cartIconWidth;
  double _height = _cartIconHeight;

  // Controller for the opening and closing of the ExpandingBottomSheet
  AnimationController get _controller => widget.expandingController;

  // Animations for the opening and closing of the ExpandingBottomSheet
  late Animation<double> _widthAnimation;
  late Animation<double> _heightAnimation;
  late Animation<double> _thumbnailOpacityAnimation;
  late Animation<double> _cartOpacityAnimation;
  late Animation<double> _topStartShapeAnimation;
  late Animation<double> _bottomStartShapeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _gapAnimation;

  Animation<double> _getWidthAnimation(double screenWidth) {
    if (_controller.status == AnimationStatus.forward) {
      // Opening animation
      return Tween<double>(begin: _width, end: screenWidth).animate(
        CurvedAnimation(
          parent: _controller.view,
          curve: const Interval(0, 0.3, curve: Curves.fastOutSlowIn),
        ),
      );
    } else {
      // Closing animation
      return _getEmphasizedEasingAnimation(
        begin: _width,
        peak: _getPeakPoint(begin: _width, end: screenWidth),
        end: screenWidth,
        isForward: false,
        parent: CurvedAnimation(
          parent: _controller.view,
          curve: const Interval(0, 0.87),
        ),
      );
    }
  }

  Animation<double> _getHeightAnimation(double screenHeight) {
    if (_controller.status == AnimationStatus.forward) {
      // Opening animation

      return _getEmphasizedEasingAnimation(
        begin: _height,
        peak: _getPeakPoint(begin: _height, end: screenHeight),
        end: screenHeight,
        isForward: true,
        parent: _controller.view,
      );
    } else {
      // Closing animation
      return Tween<double>(
        begin: _height,
        end: screenHeight,
      ).animate(
        CurvedAnimation(
          parent: _controller.view,
          curve: const Interval(0.434, 1, curve: Curves.linear), // not used
          // only the reverseCurve will be used
          reverseCurve: Interval(0.434, 1, curve: Curves.fastOutSlowIn.flipped),
        ),
      );
    }
  }

  // Animation of the top-start cut corner. It's cut when closed and not cut
  // when open.
  Animation<double> _getShapeTopStartAnimation(BuildContext context) {
    const double cornerRadius = _mobileCornerRadius;

    if (_controller.status == AnimationStatus.forward) {
      return Tween<double>(begin: cornerRadius, end: 0).animate(
        CurvedAnimation(
          parent: _controller.view,
          curve: const Interval(0, 0.3, curve: Curves.fastOutSlowIn),
        ),
      );
    } else {
      return _getEmphasizedEasingAnimation(
        begin: cornerRadius,
        peak: _getPeakPoint(begin: cornerRadius, end: 0),
        end: 0,
        isForward: false,
        parent: _controller.view,
      );
    }
  }

  // Animation of the bottom-start cut corner. It's cut when closed and not cut
  // when open.
  Animation<double> _getShapeBottomStartAnimation(BuildContext context) {
    const double cornerRadius = 0.0;

    if (_controller.status == AnimationStatus.forward) {
      return Tween<double>(begin: cornerRadius, end: 0).animate(
        CurvedAnimation(
          parent: _controller.view,
          curve: const Interval(0, 0.3, curve: Curves.fastOutSlowIn),
        ),
      );
    } else {
      return _getEmphasizedEasingAnimation(
        begin: cornerRadius,
        peak: _getPeakPoint(begin: cornerRadius, end: 0),
        end: 0,
        isForward: false,
        parent: _controller.view,
      );
    }
  }

  Animation<double> _getThumbnailOpacityAnimation() {
    return Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller.view,
        curve: _controller.status == AnimationStatus.forward
            ? const Interval(0, 0.3)
            : const Interval(0.532, 0.766),
      ),
    );
  }

  Animation<double> _getCartOpacityAnimation() {
    return CurvedAnimation(
      parent: _controller.view,
      curve: _controller.status == AnimationStatus.forward
          ? const Interval(0.3, 0.6)
          : const Interval(0.766, 1),
    );
  }

  // Returns the correct width of the ExpandingBottomSheet based on the number
  // of products and the text scaling options in the cart in the mobile layout.
  double _mobileWidthFor(int numProducts, BuildContext context) {
    final int cartThumbnailGap = numProducts > 0 ? 16 : 0;
    final double thumbnailsWidth =
        min(numProducts, constants.maxThumbnailCount) *
            _paddedThumbnailHeight(context);
    final num overflowNumberWidth = numProducts > constants.maxThumbnailCount
        ? 30 * cappedTextScale(context)
        : 0;
    return _cartIconWidth +
        cartThumbnailGap +
        thumbnailsWidth +
        overflowNumberWidth;
  }

  // Returns the correct height of the ExpandingBottomSheet based on the text
  // scaling options in the mobile layout.
  double _mobileHeightFor(BuildContext context) {
    return _paddedThumbnailHeight(context);
  }

  // Returns true if the cart is open or opening and false otherwise.
  bool get _isOpen {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  // Opens the ExpandingBottomSheet if it's closed, otherwise does nothing.
  void open() {
    if (!_isOpen) {
      _controller.forward();
    }
  }

  // Closes the ExpandingBottomSheet if it's open or opening, otherwise does
  // nothing.
  void close() {
    if (_isOpen) {
      _controller.reverse();
    }
  }

  // Changes the padding between the start edge of the Material and the cart
  // icon based on the number of products in the cart (padding increases when
  // > 0 products.)
  EdgeInsetsDirectional _horizontalCartPaddingFor(int numProducts) {
    return (numProducts == 0)
        ? const EdgeInsetsDirectional.only(start: 20, end: 8)
        : const EdgeInsetsDirectional.only(start: 32, end: 8);
  }

  bool get _cartIsVisible => _thumbnailOpacityAnimation.value == 0;

  // We take 16 pts off of the bottom padding to ensure the collapsed shopping
  // cart is not too tall.
  double get _bottomSafeArea {
    return max(MediaQuery.of(context).viewPadding.bottom - 16, 0);
  }

  Widget _buildThumbnails(BuildContext context, int numProducts) {
    Widget thumbnails;

    thumbnails = Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            AnimatedPadding(
              padding: _horizontalCartPaddingFor(numProducts),
              duration: const Duration(milliseconds: 225),
              child: const Icon(Icons.shopping_cart),
            ),
            Container(
              // Accounts for the overflow number
              width: min(numProducts, constants.maxThumbnailCount) *
                      _paddedThumbnailHeight(context) +
                  (numProducts > 0 ? _thumbnailGap : 0),
              height: _height - _bottomSafeArea,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const ProductThumbnailRow(),
            ),
            const ExtraProductsNumber(),
          ],
        ),
      ],
    );

    return ExcludeSemantics(
      child: Opacity(
        opacity: _thumbnailOpacityAnimation.value,
        child: thumbnails,
      ),
    );
  }

  Widget _buildShoppingCartPage() {
    return Opacity(
      opacity: _cartOpacityAnimation.value,
      child: const ShoppingCartPage(),
    );
  }

  Widget _buildCart(BuildContext context) {
    // numProducts is the number of different products in the cart (does not
    // include multiples of the same product).
    final AppStateModel model = ScopedModel.of<AppStateModel>(context);
    final int numProducts = model.productsInCart.keys.length;
    final int totalCartQuantity = model.totalCartQuantity;
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    final double expandedCartWidth = screenWidth;

    _width = _mobileWidthFor(numProducts, context);
    _widthAnimation = _getWidthAnimation(expandedCartWidth);
    _height = _mobileHeightFor(context) + _bottomSafeArea;
    _heightAnimation = _getHeightAnimation(screenHeight);
    _topStartShapeAnimation = _getShapeTopStartAnimation(context);
    _bottomStartShapeAnimation = _getShapeBottomStartAnimation(context);
    _thumbnailOpacityAnimation = _getThumbnailOpacityAnimation();
    _cartOpacityAnimation = _getCartOpacityAnimation();
    _gapAnimation = const AlwaysStoppedAnimation<double>(0);

    final Widget child = SizedBox(
      width: _widthAnimation.value,
      height: _heightAnimation.value,
      child: Material(
        animationDuration: const Duration(milliseconds: 0),
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(_topStartShapeAnimation.value),
            bottomStart: Radius.circular(_bottomStartShapeAnimation.value),
          ),
        ),
        elevation: 4,
        color: kAnArtistStorePink50,
        child: _cartIsVisible
            ? _buildShoppingCartPage()
            : _buildThumbnails(context, numProducts),
      ),
    );

    final Widget childWithInteraction = productPageIsVisible(context)
        ? Semantics(
            button: true,
            enabled: true,
            label: translate(
              'anArtistStoreScreenReaderCart',
              args: <String, int>{'quantity': totalCartQuantity},
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: open,
                child: child,
              ),
            ),
          )
        : child;

    return Padding(
      padding: EdgeInsets.only(top: _gapAnimation.value),
      child: childWithInteraction,
    );
  }

  // Builder for the hide and reveal animation when the backdrop opens and
  // closes.
  Widget _buildSlideAnimation(BuildContext context, Widget child) {
    final int textDirectionScalar =
        Directionality.of(context) == TextDirection.ltr ? 1 : -1;

    _slideAnimation = _getEmphasizedEasingAnimation(
      begin: Offset(1.0 * textDirectionScalar, 0.0),
      peak: Offset(_peakVelocityProgress * textDirectionScalar, 0),
      end: const Offset(0, 0),
      isForward: widget.hideController.status == AnimationStatus.forward,
      parent: widget.hideController,
    );

    return SlideTransition(
      position: _slideAnimation,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      key: _expandingBottomSheetKey,
      duration: const Duration(milliseconds: 225),
      curve: Curves.easeInOut,
      alignment: AlignmentDirectional.topStart,
      child: AnimatedBuilder(
        animation: widget.hideController,
        builder: (BuildContext context, Widget? child) => AnimatedBuilder(
          animation: widget.expandingController,
          builder: (BuildContext context, Widget? child) =>
              ScopedModelDescendant<AppStateModel>(
            builder:
                (BuildContext context, Widget? child, AppStateModel model) =>
                    _buildSlideAnimation(context, _buildCart(context)),
          ),
        ),
      ),
    );
  }
}
