import 'package:anartiststore/an_artist_store_app.dart';
import 'package:anartiststore/res/values/strings.dart';
import 'package:flutter/material.dart';

class Resources extends InheritedWidget {
  const Resources({
    super.key,
    this.strings = const Strings(),
    required super.child,
  });

  final Strings strings;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  /// Returns the nearest [Resources] widget in the ancestor tree of [context].
  ///
  /// This method asserts that the result is not `null`, as we expect the
  /// [Resources] widget to be always present in the [AnArtistStoreApp].
  /// If the [Resources] widget is not found, a runtime exception is thrown.
  static Resources of(BuildContext context) {
    Resources? resources =
        context.dependOnInheritedWidgetOfExactType<Resources>();
    if (resources != null) {
      return resources;
    } else {
      throw Exception(
        'You should wrap your app with `Resources InheritedWidget` and pass '
        'the root app widget to the child parameter.',
      );
    }
  }
}
