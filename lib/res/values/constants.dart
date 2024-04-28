const String appName = 'AnArtist.Store';
const String logoWithoutBackgroundAsset = 'assets/images/logo_without_bg.png';
const String baseUrl = 'https://an-artist.store/api/';

/// Sentinel value for the system text scale factor option.
const double systemTextScaleFactorOption = -1;

/// Maximum number of thumbnails shown in the cart.
const int maxThumbnailCount = 3;

/// Height of a thumbnail.
const double defaultThumbnailHeight = 40.0;
const double startColumnWidth = 60.0;
const int emailMaxLength = 40;
const int nameMaxLength = 33;
const int phoneMaxLength = 20;
const int addressMaxLength = 100;
const int postcodeMaxLength = 10;
const String phonePattern = r'[\+0-9]';
const String ukrainianEnglishGermanPolishPattern =
    '[a-zA-ZаАбБвВгГдДеЕєЄжЖзЗиИїЇйЙкКлЛмМнНоОпПрРсСтТуУфФхХцЦчЧшШщЩъЪыЫьЬэЭюЮяЯÄäÖöÜüẞßĄąĆćĘęŁłŃńÓóŚśŹźŻż\\s+\\b|\\b\\s|\\s|\\b]';
