import 'package:anartiststore/res/resources.dart';
import 'package:anartiststore/res/values/colors.dart';
import 'package:anartiststore/router/app_route.dart';
import 'package:anartiststore/router/routes.dart' as routes;
import 'package:flutter/material.dart';

import 'supplemental/cut_corners_border.dart';

class AnArtistStoreApp extends StatelessWidget {
  const AnArtistStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Resources.of(context).strings.title,
      initialRoute: AppRoute.home.path,
      routes: routes.routeWidgetBuilderMap,
      theme: _kAnArtistStoreTheme,
    );
  }
}

final ThemeData _kAnArtistStoreTheme = _buildAnArtistStoreTheme();

ThemeData _buildAnArtistStoreTheme() {
  final ThemeData base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: kAnArtistStorePurple,
      onPrimary: kAnArtistStoreBrown900,
      secondary: kAnArtistStorePurple,
      error: kAnArtistStoreErrorRed,
    ),
    scaffoldBackgroundColor: kAnArtistStoreSurfaceWhite,
    textTheme: _buildAnArtistStoreTextTheme(base.textTheme),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: kAnArtistStorePurple,
    ),
    appBarTheme: const AppBarTheme(
      foregroundColor: kAnArtistStoreBrown900,
      backgroundColor: kAnArtistStorePink100,
    ),
    searchViewTheme: const SearchViewThemeData(
      backgroundColor: kAnArtistStorePink100,
      surfaceTintColor: kAnArtistStorePink50,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: CutCornersBorder(),
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
  );
}

TextTheme _buildAnArtistStoreTextTheme(TextTheme base) {
  return base
      .copyWith(
        headlineSmall: base.headlineSmall!.copyWith(
          fontWeight: FontWeight.w500,
        ),
        titleLarge: base.titleLarge!.copyWith(
          fontSize: 18.0,
        ),
        bodySmall: base.bodySmall!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
        ),
        bodyLarge: base.bodyLarge!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
        ),
      )
      .apply(
        fontFamily: 'Rubik',
        displayColor: kAnArtistStoreBrown900,
        bodyColor: kAnArtistStoreBrown900,
      );
}
