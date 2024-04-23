import 'package:anartiststore/model_binding/model_binding.dart';
import 'package:flutter/material.dart';

/// Everything below is boilerplate except code relating to time dilation.
/// See https://medium.com/flutter/managing-flutter-application-state-with-inheritedwidgets-1140452befe1
class ModelBindingScope extends InheritedWidget {
  const ModelBindingScope({
    super.key,
    required this.modelBindingState,
    required super.child,
  });

  final ModelBindingState modelBindingState;

  @override
  bool updateShouldNotify(ModelBindingScope oldWidget) => true;
}
