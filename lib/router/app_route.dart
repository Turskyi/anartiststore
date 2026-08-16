enum AppRoute {
  home('/'),
  login('/login'),
  productDetails('/productDetails'),
  aboutUs('/aboutUs'),
  contact('/contact'),
  termsOfUse('/termsOfUse'),
  privacyPolicy('/privacyPolicy'),
  cookiePolicy('/cookiePolicy');

  const AppRoute(this.path);

  final String path;
}
