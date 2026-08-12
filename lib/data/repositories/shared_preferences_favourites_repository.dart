import 'package:anartiststore/model/favourites_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesFavouritesRepository implements FavouritesRepository {
  static const String _kFavouritesKey = 'favourite_product_ids';

  @override
  Future<Set<String>> getFavouriteIds() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? ids = prefs.getStringList(_kFavouritesKey);
    return ids?.toSet() ?? <String>{};
  }

  @override
  Future<void> addFavourite(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Set<String> favourites = await getFavouriteIds();
    favourites.add(id);
    await prefs.setStringList(_kFavouritesKey, favourites.toList());
  }

  @override
  Future<void> removeFavourite(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Set<String> favourites = await getFavouriteIds();
    favourites.remove(id);
    await prefs.setStringList(_kFavouritesKey, favourites.toList());
  }

  @override
  Future<bool> isFavourite(String id) async {
    final Set<String> favourites = await getFavouriteIds();
    return favourites.contains(id);
  }
}
