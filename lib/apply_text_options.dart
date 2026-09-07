import 'package:anartiststore/data/app_options.dart';
import 'package:flutter/material.dart';

/// Applies text [AppOptions] to a widget.
class ApplyTextOptions extends StatelessWidget {
  const ApplyTextOptions({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final AppOptions options = AppOptions.of(context);
    final TextDirection? textDirection = options.resolvedTextDirection();

    Widget widget = MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: MediaQuery.textScalerOf(context)),
      child: child,
    );
    return textDirection == null
        ? widget
        : Directionality(textDirection: textDirection, child: widget);
  }
}
