import 'package:anartiststore/res/values/colors.dart';
import 'package:anartiststore/theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  group('AnArtistStore Theme', () {
    test('Light theme should be defined correctly', () {
      expect(kAnArtistStoreTheme.brightness, Brightness.light);
      expect(kAnArtistStoreTheme.colorScheme.primary, kAnArtistStoreTeal);
      expect(kAnArtistStoreTheme.colorScheme.error, kAnArtistStoreErrorRed);
    });

    test('Text theme should be defined correctly', () {
      final TextTheme textTheme = kAnArtistStoreTheme.textTheme;
      expect(textTheme.headlineSmall?.fontWeight, FontWeight.w500);
      expect(textTheme.titleLarge?.fontSize, 18.0);
    });
  });
}
