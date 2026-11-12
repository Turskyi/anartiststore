import 'package:anartiststore/layout/text_scale.dart';
import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:material_ui/material_ui.dart';

double thumbnailHeight(BuildContext context) =>
    constants.defaultThumbnailHeight * reducedTextScale(context);
