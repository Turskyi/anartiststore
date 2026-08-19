import 'package:anartiststore/layout/letter_spacing.dart';
import 'package:anartiststore/res/values/colors.dart';
import 'package:anartiststore/supplemental/cut_corners_border.dart';
import 'package:flutter/material.dart';

const double defaultLetterSpacing = 0.03;
const double mediumLetterSpacing = 0.04;
const double largeLetterSpacing = 1.0;

final ThemeData kAnArtistStoreTheme = _buildAnArtistStoreTheme();
final ThemeData kAnArtistStoreDarkTheme = _buildAnArtistStoreDarkTheme();

IconThemeData _customIconTheme(IconThemeData original, Color color) {
  return original.copyWith(color: color);
}

ThemeData _buildAnArtistStoreTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    appBarTheme: const AppBarTheme(
      foregroundColor: kAnArtistStoreGreen900,
      backgroundColor: kAnArtistStoreBlue100,
    ),
    scaffoldBackgroundColor: kAnArtistStoreSurfaceWhite,
    cardColor: Colors.white,
    primaryIconTheme: _customIconTheme(base.iconTheme, kAnArtistStoreGreen900),
    inputDecorationTheme: const InputDecorationTheme(
      border: CutCornersBorder(
        borderSide: BorderSide(color: kAnArtistStoreGreen900, width: 0.5),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      focusedBorder: CutCornersBorder(
        borderSide: BorderSide(
          width: 2.0,
          color: kAnArtistStoreTeal,
        ),
      ),
      floatingLabelStyle: TextStyle(
        color: kAnArtistStoreTeal,
      ),
    ),
    textTheme: _buildAnArtistStoreTextTheme(
      base.textTheme,
      kAnArtistStoreGreen900,
      kAnArtistStoreGreen900,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: kAnArtistStoreTeal,
    ),
    primaryTextTheme: _buildAnArtistStoreTextTheme(
      base.primaryTextTheme,
      kAnArtistStoreGreen900,
      kAnArtistStoreGreen900,
    ),
    iconTheme: _customIconTheme(base.iconTheme, kAnArtistStoreGreen900),
    colorScheme: base.colorScheme.copyWith(
      error: kAnArtistStoreErrorRed,
      primary: kAnArtistStoreTeal,
      onPrimary: Colors.white,
      secondary: kAnArtistStoreTeal,
      onSecondary: Colors.white,
      primaryContainer: kAnArtistStoreGreen900,
      onPrimaryContainer: Colors.white,
      secondaryContainer: kAnArtistStoreBlue50,
      onSecondaryContainer: kAnArtistStoreGreen900,
      surface: kAnArtistStoreSurfaceWhite,
      onSurface: kAnArtistStoreGreen900,
      onError: kAnArtistStoreSurfaceWhite,
      brightness: Brightness.light,
    ),
    dividerTheme: const DividerThemeData(
      color: kAnArtistStoreGreen900,
      thickness: 1,
    ),
    searchViewTheme: const SearchViewThemeData(
      backgroundColor: kAnArtistStoreBlue100,
      surfaceTintColor: Colors.transparent,
    ),
  );
}

ThemeData _buildAnArtistStoreDarkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    appBarTheme: const AppBarTheme(
      foregroundColor: kAnArtistStoreOnSurfaceDark,
      backgroundColor: kAnArtistStoreBackgroundDark,
    ),
    scaffoldBackgroundColor: kAnArtistStoreBackgroundDark,
    cardColor: kAnArtistStoreSurfaceDark,
    primaryIconTheme:
        _customIconTheme(base.iconTheme, kAnArtistStoreOnSurfaceDark),
    inputDecorationTheme: const InputDecorationTheme(
      border: CutCornersBorder(
        borderSide: BorderSide(color: kAnArtistStoreOnSurfaceDark, width: 0.5),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      focusedBorder: CutCornersBorder(
        borderSide: BorderSide(
          width: 2.0,
          color: kAnArtistStoreTeal,
        ),
      ),
      floatingLabelStyle: TextStyle(
        color: kAnArtistStoreTeal,
      ),
    ),
    textTheme: _buildAnArtistStoreTextTheme(
      base.textTheme,
      kAnArtistStoreOnSurfaceDark,
      kAnArtistStoreOnSurfaceDark,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: kAnArtistStoreTeal,
    ),
    primaryTextTheme: _buildAnArtistStoreTextTheme(
      base.primaryTextTheme,
      kAnArtistStoreOnSurfaceDark,
      kAnArtistStoreOnSurfaceDark,
    ),
    iconTheme: _customIconTheme(base.iconTheme, kAnArtistStoreOnSurfaceDark),
    colorScheme: base.colorScheme.copyWith(
      error: kAnArtistStoreErrorRed,
      primary: kAnArtistStoreTeal,
      onPrimary: Colors.white,
      secondary: kAnArtistStoreTeal,
      onSecondary: Colors.white,
      primaryContainer: kAnArtistStoreTeal,
      onPrimaryContainer: Colors.white,
      secondaryContainer: kAnArtistStoreSurfaceDark,
      onSecondaryContainer: kAnArtistStoreOnSurfaceDark,
      surface: kAnArtistStoreSurfaceDark,
      onSurface: kAnArtistStoreOnSurfaceDark,
      onError: kAnArtistStoreSurfaceWhite,
      brightness: Brightness.dark,
    ),
    dividerTheme: const DividerThemeData(
      color: kAnArtistStoreOnSurfaceDark,
      thickness: 1,
    ),
    searchViewTheme: const SearchViewThemeData(
      backgroundColor: kAnArtistStoreSurfaceDark,
      surfaceTintColor: Colors.transparent,
    ),
  );
}

TextTheme _buildAnArtistStoreTextTheme(
  TextTheme base,
  Color displayColor,
  Color bodyColor,
) {
  return base
      .copyWith(
        headlineSmall: base.headlineSmall?.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
        ),
        titleLarge: base.titleLarge?.copyWith(
          fontSize: 18.0,
          letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
        ),
        bodySmall: base.bodySmall?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
          letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
        ),
        bodyLarge: base.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
          letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
        ),
        titleMedium: base.titleMedium?.copyWith(
          letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
        ),
        bodyMedium: base.bodyMedium?.copyWith(
          letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
        ),
        headlineMedium: base.headlineMedium?.copyWith(
          letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
        ),
        labelLarge: base.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
        ),
      )
      .apply(
        fontFamily: 'Rubik',
        displayColor: displayColor,
        bodyColor: bodyColor,
      );
}
