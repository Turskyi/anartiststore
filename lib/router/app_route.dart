enum AppRoute {
  home('/'),
  login('/login'),
  productDetails('/productDetails'),
  aboutUs('/aboutUs');

  const AppRoute(this.path);

  final String path;
}
