enum Group {
  all,
  favourites;

  bool get isAll => this == all;

  bool get isFavourites => this == favourites;
}
