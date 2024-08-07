import 'package:anartiststore/an_artist_store_app.dart';
import 'package:anartiststore/data/app_options.dart';
import 'package:anartiststore/enums/app_text_direction.dart';
import 'package:anartiststore/localization_delelegate_getter.dart';
import 'package:anartiststore/model_binding/model_binding.dart';
import 'package:anartiststore/res/resources.dart';
import 'package:anartiststore/res/values/constants.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

void main() async {
  final LocalizationDelegate localizationDelegate =
      await getLocalizationDelegate();

  runApp(
    BetterFeedback(
      child: LocalizedApp(
        localizationDelegate,
        Resources(
          child: ModelBinding(
            initialModel: AppOptions(
              themeMode: ThemeMode.system,
              textScaleFactor: systemTextScaleFactorOption,
              customTextDirection: AppTextDirection.localeBased,
              platform: defaultTargetPlatform,
            ),
            child: const AnArtistStoreApp(),
          ),
        ),
      ),
    ),
  );
}
