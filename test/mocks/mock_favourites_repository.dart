import 'package:anartiststore/model/favourites_repository.dart';

class MockFavouritesRepository implements FavouritesRepository {
  @override
  Future<Set<String>> getFavouriteIds() async => <String>{};
  @override
  Future<void> addFavourite(String id) async {}
  @override
  Future<void> removeFavourite(String id) async {}
  @override
  Future<bool> isFavourite(String id) async => false;
}
