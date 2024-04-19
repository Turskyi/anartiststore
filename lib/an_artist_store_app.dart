import 'package:anartiststore/enums/group.dart';
import 'package:anartiststore/group/group_menu_page.dart';
import 'package:anartiststore/res/resources.dart';
import 'package:anartiststore/res/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'backdrop/backdrop.dart';
import 'home.dart';
import 'login.dart';
import 'supplemental/cut_corners_border.dart';

class AnArtistStoreApp extends StatefulWidget {
  const AnArtistStoreApp({super.key});

  @override
  State<AnArtistStoreApp> createState() => _AnArtistStoreAppState();
}

class _AnArtistStoreAppState extends State<AnArtistStoreApp> {
  final ValueNotifier<Group> _groupNotifier = ValueNotifier<Group>(Group.all);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Resources.of(context).strings.title,
      initialRoute: '/login',
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => const LoginPage(),
        '/': (BuildContext context) => ValueListenableBuilder<Group>(
              valueListenable: _groupNotifier,
              builder: (BuildContext context, Group currentGroup, _) {
                return Backdrop(
                  currentCategory: currentGroup,
                  frontLayer: HomePage(category: currentGroup),
                  backLayer: GroupMenuPage(
                    currentCategory: currentGroup,
                    onCategoryTap: _onGroupTap,
                  ),
                  frontTitle: Text(Resources.of(context).strings.title),
                  backTitle: Text(translate('menu')),
                );
              },
            ),
      },
      theme: _kAnArtistStoreTheme,
    );
  }

  @override
  void dispose() {
    _groupNotifier.dispose();
    super.dispose();
  }

  /// Function to call when a [Group] is tapped.
  void _onGroupTap(Group group) => _groupNotifier.value = group;
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
