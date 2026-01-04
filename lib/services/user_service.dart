import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static const String baseUrl = 'http://localhost:8080/api';

  static Future<Map<String, dynamic>?> getUser() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        print('Loaded user data from API');
        return data['user'];
      } else {
        print('Error loading user: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error loading user: $e');
      return null;
    }
  }

  static Future<List<dynamic>> getUserTrips() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/trips'));

      if (response.statusCode == 200) {
        final trips = jsonDecode(response.body) as List;
        print('Loaded ${trips.length} user trips from API');
        return trips;
      } else {
        print('Error loading trips: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error loading trips: $e');
      return [];
    }
  }

  static Future<List<dynamic>> getUserFavorites() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/favorites'));

      if (response.statusCode == 200) {
        final favorites = jsonDecode(response.body) as List;
        print('Loaded ${favorites.length} user favorites from API');
        return favorites;
      } else {
        print('Error loading favorites: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error loading favorites: $e');
      return [];
    }
  }

  static Future<List<dynamic>> getUserNotes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final notes = data['user']['notesOfTheTrip'] as List? ?? [];
        print('Loaded ${notes.length} user notes from API');
        return notes;
      } else {
        print('Error loading notes: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error loading notes: $e');
      return [];
    }
  }

  static Future<void> removeFavorite(int favoriteId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/favorites/$favoriteId'),
      );

      if (response.statusCode == 200) {
        print('Favorite $favoriteId removed successfully');
      } else {
        print('Error removing favorite: ${response.statusCode}');
      }
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

  static Future<void> addFavorite(Map<String, dynamic> favorite) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/favorites'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(favorite),
      );

      if (response.statusCode == 201) {
        print('Favorite added successfully');
      } else {
        print('Error adding favorite: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }

  static Future<void> saveNote(int tripId, String noteText) async {
    try {
      print('DEBUG: Saving note for trip $tripId');
      print('DEBUG: Note text: "$noteText"');
      
      final response = await http.post(
        Uri.parse('$baseUrl/trips/$tripId/notes'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'noteText': noteText,
        }),
      );

      print('DEBUG: Save note response status: ${response.statusCode}');
      print('DEBUG: Save note response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Note saved successfully for trip $tripId');
      } else {
        print('Error saving note: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving note: $e');
    }
  }

  static Future<String> getNote(int tripId) async {
    try {
      print('DEBUG: Fetching note from API for trip $tripId');
      final response = await http.get(
        Uri.parse('$baseUrl/trips/$tripId/notes'),
      );

      print('DEBUG: Note API response status: ${response.statusCode}');
      print('DEBUG: Note API response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final noteText = data['noteText'] ?? '';
        print('Loaded note for trip $tripId: "$noteText"');
        return noteText;
      } else if (response.statusCode == 404) {
        print('No note found for trip $tripId (404)');
        return '';
      } else {
        print('Error loading note: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      print('Error loading note: $e');
      return '';
    }
  }
}
