enum AppRoute {
  home('/'),
  login('/login');

  const AppRoute(this.path);

  final String path;
}
