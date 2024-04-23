import 'package:anartiststore/enums/app_text_direction.dart';
import 'package:anartiststore/model_binding/model_binding_scope.dart';
import 'package:anartiststore/res/values/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

// See http://en.wikipedia.org/wiki/Right-to-left
const List<String> rtlLanguages = <String>[
  'ar', // Arabic
  'fa', // Farsi
  'he', // Hebrew
  'ps', // Pashto
  'ur', // Urdu
];

Locale? _deviceLocale;

Locale? get deviceLocale => _deviceLocale;

set deviceLocale(Locale? locale) {
  _deviceLocale ??= locale;
}

class AppOptions {
  const AppOptions({
    required this.themeMode,
    required double? textScaleFactor,
    required this.customTextDirection,
    Locale? locale,
    this.timeDilation = 1.0,
    required this.platform,
    this.isTestMode = kDebugMode,
  })  : _textScaleFactor = textScaleFactor ?? 1.0,
        _locale = locale;

  final ThemeMode themeMode;
  final double _textScaleFactor;
  final AppTextDirection customTextDirection;
  final Locale? _locale;
  final double timeDilation;
  final TargetPlatform? platform;
  final bool isTestMode; // True for integration tests.

  // We use a sentinel value to indicate the system text scale option. By
  // default, return the actual text scale factor, otherwise return the
  // sentinel value.
  double textScaleFactor(BuildContext context, {bool useSentinel = false}) {
    if (_textScaleFactor == systemTextScaleFactorOption) {
      return useSentinel
          ? systemTextScaleFactorOption
          : MediaQuery.textScalerOf(context).scale(1);
    } else {
      return _textScaleFactor;
    }
  }

  Locale? get locale => _locale ?? deviceLocale;

  /// Returns a text direction based on the [AppTextDirection] setting.
  /// If it is based on locale and the locale cannot be determined, returns
  /// null.
  TextDirection? resolvedTextDirection() {
    switch (customTextDirection) {
      case AppTextDirection.localeBased:
        final String? language = locale?.languageCode.toLowerCase();
        if (language == null) return null;
        return rtlLanguages.contains(language)
            ? TextDirection.rtl
            : TextDirection.ltr;
      case AppTextDirection.rtl:
        return TextDirection.rtl;
      default:
        return TextDirection.ltr;
    }
  }

  /// Returns a [SystemUiOverlayStyle] based on the [ThemeMode] setting.
  /// In other words, if the theme is dark, returns light; if the theme is
  /// light, returns dark.
  SystemUiOverlayStyle resolvedSystemUiOverlayStyle() {
    Brightness brightness;
    switch (themeMode) {
      case ThemeMode.light:
        brightness = Brightness.light;
        break;
      case ThemeMode.dark:
        brightness = Brightness.dark;
        break;
      default:
        brightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
    }

    final SystemUiOverlayStyle overlayStyle = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    return overlayStyle;
  }

  AppOptions copyWith({
    ThemeMode? themeMode,
    double? textScaleFactor,
    AppTextDirection? customTextDirection,
    Locale? locale,
    double? timeDilation,
    TargetPlatform? platform,
    bool? isTestMode,
  }) =>
      AppOptions(
        themeMode: themeMode ?? this.themeMode,
        textScaleFactor: textScaleFactor ?? _textScaleFactor,
        customTextDirection: customTextDirection ?? this.customTextDirection,
        locale: locale ?? this.locale,
        timeDilation: timeDilation ?? this.timeDilation,
        platform: platform ?? this.platform,
        isTestMode: isTestMode ?? this.isTestMode,
      );

  @override
  bool operator ==(Object other) =>
      other is AppOptions &&
      themeMode == other.themeMode &&
      _textScaleFactor == other._textScaleFactor &&
      customTextDirection == other.customTextDirection &&
      locale == other.locale &&
      timeDilation == other.timeDilation &&
      platform == other.platform &&
      isTestMode == other.isTestMode;

  @override
  int get hashCode => Object.hash(
        themeMode,
        _textScaleFactor,
        customTextDirection,
        locale,
        timeDilation,
        platform,
        isTestMode,
      );

  static AppOptions of(BuildContext context) {
    final ModelBindingScope scope =
        context.dependOnInheritedWidgetOfExactType<ModelBindingScope>()!;
    return scope.modelBindingState.currentModel;
  }

  static void update(BuildContext context, AppOptions newModel) {
    final ModelBindingScope scope =
        context.dependOnInheritedWidgetOfExactType<ModelBindingScope>()!;
    scope.modelBindingState.updateModel(newModel);
  }
}
