/// [Language] is an `enum` object that contains all supported languages by
/// project.
enum Language {
  en(
    name: _englishLanguage,
    isoLanguageCode: englishIsoLanguageCode,
    flag: '🇬🇧',
  ),
  uk(
    name: _ukrainianLanguage,
    isoLanguageCode: _ukrainianIsoLanguageCode,
    flag: '🇺🇦',
  );

  const Language({
    required this.name,
    required this.isoLanguageCode,
    required this.flag,
  });

  final String name;
  final String isoLanguageCode;
  final String flag;

  bool get isEnglish => this == Language.en;

  static Language fromIsoLanguageCode(String isoLanguageCode) {
    switch (isoLanguageCode.trim().toLowerCase()) {
      case englishIsoLanguageCode:
        return Language.en;
      case _ukrainianIsoLanguageCode:
        return Language.uk;
      default:
        return Language.en;
    }
  }
}

const String englishIsoLanguageCode = 'en_GB';
const String _ukrainianIsoLanguageCode = 'uk_UA';
const String _englishLanguage = 'English';
const String _ukrainianLanguage = 'Ukrainian';
