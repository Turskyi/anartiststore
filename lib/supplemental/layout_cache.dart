import 'package:flutter/material.dart';

class LayoutCache extends InheritedWidget {
  const LayoutCache({required this.layouts, required super.child, super.key});

  static Map<String, List<List<int>>> of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LayoutCache>()!.layouts;
  }

  final Map<String, List<List<int>>> layouts;

  @override
  bool updateShouldNotify(LayoutCache oldWidget) => true;
}
