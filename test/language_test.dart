import 'package:anartiststore/enums/language.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Language.fromIsoLanguageCode', () {
    test('should return Language.en for "en_GB"', () {
      expect(Language.fromIsoLanguageCode('en_GB'), Language.en);
    });

    test('should return Language.en for "en" (case-insensitive)', () {
      expect(Language.fromIsoLanguageCode('en'), Language.en);
      expect(Language.fromIsoLanguageCode('EN'), Language.en);
    });

    test('should return Language.uk for "uk_UA" (case-insensitive)', () {
      expect(Language.fromIsoLanguageCode('uk_UA'), Language.uk);
      expect(Language.fromIsoLanguageCode('UK_ua'), Language.uk);
    });

    test('should return Language.uk for "uk"', () {
      expect(Language.fromIsoLanguageCode('uk'), Language.uk);
    });

    test('should return Language.pl for "pl_PL" (case-insensitive)', () {
      expect(Language.fromIsoLanguageCode('pl_PL'), Language.pl);
      expect(Language.fromIsoLanguageCode('PL_pl'), Language.pl);
    });

    test('should return Language.pl for "pl"', () {
      expect(Language.fromIsoLanguageCode('pl'), Language.pl);
    });

    test('should return Language.en for unknown codes', () {
      expect(Language.fromIsoLanguageCode('fr_FR'), Language.en);
      expect(Language.fromIsoLanguageCode(''), Language.en);
    });
  });
}
