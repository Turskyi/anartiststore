enum AppRoute {
  home('/'),
  login('/login'),
  productDetails('/productDetails');

  const AppRoute(this.path);

  final String path;
}
