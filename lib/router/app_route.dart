enum AppRoute {
  home('/'),
  login('/login'),
  productDetails('/productDetails'),
  aboutUs('/aboutUs'),
  contact('/contact');

  const AppRoute(this.path);

  final String path;
}
