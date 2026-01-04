import 'package:shared_preferences/shared_preferences.dart';

class NotesService {
  static const String _notesPrefix = 'note_trip_';

  static Future<String> getNote(int tripId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final noteKey = '$_notesPrefix$tripId';
      final noteText = prefs.getString(noteKey) ?? '';
      
      print('DEBUG: Loaded local note for trip $tripId: "$noteText"');
      return noteText;
    } catch (e) {
      print('Error loading local note: $e');
      return '';
    }
  }

  static Future<void> saveNote(int tripId, String noteText) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final noteKey = '$_notesPrefix$tripId';
      await prefs.setString(noteKey, noteText);
      
      print('DEBUG: Saved local note for trip $tripId: "$noteText"');
    } catch (e) {
      print('Error saving local note: $e');
    }
  }

  static Future<void> deleteNote(int tripId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final noteKey = '$_notesPrefix$tripId';
      await prefs.remove(noteKey);
      
      print('DEBUG: Deleted local note for trip $tripId');
    } catch (e) {
      print('Error deleting local note: $e');
    }
  }
}
