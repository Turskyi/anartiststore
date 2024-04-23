import 'package:anartiststore/layout/text_scale.dart';
import 'package:anartiststore/res/values/constants.dart' as constants;
import 'package:flutter/material.dart';

double thumbnailHeight(BuildContext context) =>
    constants.defaultThumbnailHeight * reducedTextScale(context);
