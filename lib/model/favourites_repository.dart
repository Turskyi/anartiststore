abstract interface class FavouritesRepository {
  Future<Set<String>> getFavouriteIds();

  Future<void> addFavourite(String id);

  Future<void> removeFavourite(String id);

  Future<bool> isFavourite(String id);
}
