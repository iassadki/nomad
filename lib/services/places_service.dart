import 'dart:convert';
import 'package:flutter/services.dart';

class PlacesService {
  static Future<List<dynamic>> loadPlaces(String city) async {
    try {
      final String cityKey = city.toLowerCase();
      final String fileName = cityKey == 'porto' 
          ? 'assets/api/porto_places.json'
          : 'assets/api/lisboa_places.json';
      
      final String response = await rootBundle.loadString(fileName);
      final data = json.decode(response);
      
      print('DEBUG: Loaded JSON for $city: $data');
      
      // Extrait les places selon la structure JSON
      final places = data['cities'][cityKey]?['places'] ?? [];
      print('Loaded ${places.length} places for $city from $fileName');
      print('DEBUG: Places = $places');
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
