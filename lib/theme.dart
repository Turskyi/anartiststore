import 'package:anartiststore/layout/letter_spacing.dart';
import 'package:anartiststore/res/values/colors.dart';
import 'package:anartiststore/supplemental/cut_corners_border.dart';
import 'package:flutter/material.dart';

const double defaultLetterSpacing = 0.03;
const double mediumLetterSpacing = 0.04;
const double largeLetterSpacing = 1.0;

final ThemeData kAnArtistStoreTheme = _buildAnArtistStoreTheme();

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: kAnArtistStoreBrown900);
}

ThemeData _buildAnArtistStoreTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    appBarTheme: const AppBarTheme(
      foregroundColor: kAnArtistStoreBrown900,
      backgroundColor: kAnArtistStorePink100,
    ),
    scaffoldBackgroundColor: kAnArtistStoreSurfaceWhite,
    cardColor: kAnArtistStoreBackgroundWhite,
    primaryIconTheme: _customIconTheme(base.iconTheme),
    inputDecorationTheme: const InputDecorationTheme(
      border: CutCornersBorder(
        borderSide: BorderSide(color: kAnArtistStoreBrown900, width: 0.5),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      focusedBorder: CutCornersBorder(
        borderSide: BorderSide(
          width: 2.0,
          color: kAnArtistStorePurple,
        ),
      ),
      floatingLabelStyle: TextStyle(
        color: kAnArtistStorePurple,
      ),
    ),
    textTheme: _buildAnArtistStoreTextTheme(base.textTheme),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: kAnArtistStorePurple,
    ),
    primaryTextTheme: _buildAnArtistStoreTextTheme(base.primaryTextTheme),
    iconTheme: _customIconTheme(base.iconTheme),
    colorScheme: base.colorScheme.copyWith(
      error: kAnArtistStoreErrorRed,
      primary: kAnArtistStorePurple,
      onPrimary: kAnArtistStoreBrown900,
      secondary: kAnArtistStorePurple,
      primaryContainer: kAnArtistStoreBrown900,
      secondaryContainer: kAnArtistStoreBrown900,
      surface: kAnArtistStoreSurfaceWhite,
      background: kAnArtistStoreBackgroundWhite,
      onSecondary: kAnArtistStoreBrown900,
      onSurface: kAnArtistStoreBrown900,
      onBackground: kAnArtistStoreBrown900,
      onError: kAnArtistStoreSurfaceWhite,
      brightness: Brightness.light,
    ),
    searchViewTheme: const SearchViewThemeData(
      backgroundColor: kAnArtistStorePink100,
      surfaceTintColor: kAnArtistStorePink50,
    ),
  );
}

TextTheme _buildAnArtistStoreTextTheme(TextTheme base) {
  return base
      .copyWith(
        headlineSmall: base.headlineSmall!.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
        ),
        titleLarge: base.titleLarge!.copyWith(
          fontSize: 18.0,
          letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
        ),
        bodySmall: base.bodySmall!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
          letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
        ),
        bodyLarge: base.bodyLarge!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
          letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
        ),
        titleMedium: base.titleMedium!.copyWith(
          letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
        ),
        bodyMedium: base.bodyMedium!.copyWith(
          letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
        ),
        headlineMedium: base.headlineMedium!.copyWith(
          letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
        ),
        labelLarge: base.labelLarge!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          letterSpacing: letterSpacingOrNone(defaultLetterSpacing),
        ),
      )
      .apply(
        fontFamily: 'Rubik',
        displayColor: kAnArtistStoreBrown900,
        bodyColor: kAnArtistStoreBrown900,
      );
}
