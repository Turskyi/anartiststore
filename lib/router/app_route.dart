enum AppRoute {
  home('/'),
  login('/login'),
  productDetails('/productDetails'),
  aboutUs('/aboutUs'),
  contact('/contact'),
  termsOfUse('/termsOfUse');

  const AppRoute(this.path);

  final String path;
}
