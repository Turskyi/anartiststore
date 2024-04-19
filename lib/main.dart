import 'package:anartiststore/an_artist_store_app.dart';
import 'package:anartiststore/res/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

void main() async {
  LocalizationDelegate delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en_US',
    supportedLocales: <String>['en_US', 'uk_UA'],
  );
  runApp(LocalizedApp(delegate, const Resources(child: AnArtistStoreApp())));
}
