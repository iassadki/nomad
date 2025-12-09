import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String key = 'favorite_places';

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  static Future<void> toggleFavorite(String placeId) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(key) ?? [];

    if (favs.contains(placeId)) {
      favs.remove(placeId);
    } else {
      favs.add(placeId);
    }

    await prefs.setStringList(key, favs);
  }

  static Future<bool> isFavorite(String placeId) async {
    final favs = await getFavorites();
    return favs.contains(placeId);
  }
}
