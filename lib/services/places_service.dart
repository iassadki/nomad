import 'dart:convert';
import 'package:flutter/services.dart';

class PlacesService {
  static Future<List<dynamic>> loadPlaces(String city) async {
    try {
      final String fileName = city.toLowerCase() == 'lisboa' 
          ? 'assets/api/lisboa_places.json'
          : 'assets/api/porto_places.json';
      
      final String response = await rootBundle.loadString(fileName);
      final data = json.decode(response);
      
      // Extrait les places selon la structure JSON
      final places = data['cities'][city.toLowerCase()]?['places'] ?? [];
      print('Loaded ${places.length} places for $city');
      return places;
    } catch (e) {
      print('Error loading places for $city: $e');
      return [];
    }
  }

  static Future<List<dynamic>> searchPlaces(String query) async {
    try {
      // Charger les places de Porto et Lisboa
      final portePlaces = await loadPlaces('porto');
      final lisboaPlaces = await loadPlaces('lisboa');
      
      // Combiner les résultats
      final allPlaces = [
        ...portePlaces.map((p) => {...p, 'city': 'Porto'}),
        ...lisboaPlaces.map((p) => {...p, 'city': 'Lisboa'}),
      ];
      
      // Filtrer par recherche
      if (query.isEmpty) {
        return allPlaces;
      }
      
      final results = allPlaces.where((place) {
        final name = (place['placeName'] as String).toLowerCase();
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
