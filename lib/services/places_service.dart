import 'dart:convert';
import 'package:http/http.dart' as http;

class PlacesService {
  static const String baseUrl = 'http://localhost:8080/api';

  static Future<List<dynamic>> loadPlaces(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/places/${city.toLowerCase()}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final places = data['places'] ?? [];
        print('Loaded ${places.length} places for $city from API');
        return places;
      } else {
        print('Error loading places for $city: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error loading places for $city: $e');
      return [];
    }
  }

  static Future<List<dynamic>> searchPlaces(String query) async {
    try {
      // Charger les places de Porto et Lisboa depuis l'API
      final portePlaces = await loadPlaces('porto');
      final lisboaPlaces = await loadPlaces('lisboa');

      print('Loaded ${portePlaces.length} places from Porto');
      print('Loaded ${lisboaPlaces.length} places from Lisboa');

      // Combiner les résultats avec la ville attribuée
      final allPlaces = <Map<String, dynamic>>[
        ...portePlaces.map((p) {
          final place = Map<String, dynamic>.from(p as Map);
          place['city'] = 'Porto';
          return place;
        }),
        ...lisboaPlaces.map((p) {
          final place = Map<String, dynamic>.from(p as Map);
          place['city'] = 'Lisboa';
          return place;
        }),
      ];

      print('Total combined places: ${allPlaces.length}');

      // Filtrer par recherche
      if (query.isEmpty) {
        return allPlaces;
      }

      final results = allPlaces.where((place) {
        final name = (place['placeName'] as String?)?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase());
      }).toList();

      print('Search for "$query" returned ${results.length} results');
      return results;
    } catch (e) {
      print('Error searching places: $e');
      return [];
    }
  }
}
