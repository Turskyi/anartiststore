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
  ),
  pl(
    name: _polishLanguage,
    isoLanguageCode: _polishIsoLanguageCode,
    flag: '🇵🇱',
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
    final String code = isoLanguageCode.trim().toLowerCase();
    if (code.startsWith(englishIsoLanguageCode.toLowerCase()) || code == 'en') {
      return Language.en;
    } else if (code.startsWith(_ukrainianIsoLanguageCode.toLowerCase()) ||
        code == 'uk') {
      return Language.uk;
    } else if (code.startsWith(_polishIsoLanguageCode.toLowerCase()) ||
        code == 'pl') {
      return Language.pl;
    }
    return Language.en;
  }
}

const String englishIsoLanguageCode = 'en_GB';
const String _ukrainianIsoLanguageCode = 'uk_UA';
const String _polishIsoLanguageCode = 'pl_PL';
const String _englishLanguage = 'English';
const String _ukrainianLanguage = 'Ukrainian';
const String _polishLanguage = 'Polski';
