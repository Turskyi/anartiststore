import 'package:anartiststore/apply_text_options.dart';
import 'package:anartiststore/cart/expanding_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

const String _ordinalSortKeyName = 'home';

class HomePage extends StatelessWidget {
  const HomePage({
    this.expandingBottomSheet,
    this.scrim,
    this.backdrop,
    super.key,
  });

  final ExpandingBottomSheet? expandingBottomSheet;
  final Widget? scrim;
  final Widget? backdrop;

  @override
  Widget build(BuildContext context) {
    // Use sort keys to make sure the cart button is always on the top.
    // This way, a11y users do not have to scroll through the entire list to
    // find the cart, and can easily get to the cart from anywhere on the page.
    return ApplyTextOptions(
      child: Stack(
        children: <Widget>[
          Semantics(
            container: true,
            sortKey: const OrdinalSortKey(1, name: _ordinalSortKeyName),
            child: backdrop,
          ),
          ExcludeSemantics(child: scrim),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Semantics(
              container: true,
              sortKey: const OrdinalSortKey(0, name: _ordinalSortKeyName),
              child: expandingBottomSheet,
            ),
          ),
        ],
      ),
    );
  }
}
