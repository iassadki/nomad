import 'auth_service.dart';

class NotesService {
  static Future<String> getNote(int tripId) async {
    try {
      final currentUser = AuthService.currentUser;
      if (currentUser == null) {
        print('Error: No user logged in');
        return '';
      }

      final noteText = currentUser.notes[tripId] ?? '';
      print('DEBUG: Loaded note for trip $tripId: "$noteText"');
      return noteText;
    } catch (e) {
      print('Error loading local note: $e');
      return '';
    }
  }

  static Future<void> saveNote(int tripId, String noteText) async {
    try {
      final currentUser = AuthService.currentUser;
      if (currentUser == null) {
        print('Error: No user logged in');
        return;
      }

      // Mettre à jour la note du voyage
      final updatedNotes = {...currentUser.notes, tripId: noteText};
      final updatedUser = currentUser.copyWith(notes: updatedNotes);
      
      // Mettre à jour le user
      await AuthService.updateCurrentUser(updatedUser);
      
      print('DEBUG: Saved note for trip $tripId: "$noteText"');
    } catch (e) {
      print('Error saving local note: $e');
    }
  }

  static Future<void> deleteNote(int tripId) async {
    try {
      final currentUser = AuthService.currentUser;
      if (currentUser == null) {
        print('Error: No user logged in');
        return;
      }

      // Supprimer la note du voyage
      final updatedNotes = {...currentUser.notes};
      updatedNotes.remove(tripId);
      final updatedUser = currentUser.copyWith(notes: updatedNotes);
      
      // Mettre à jour le user
      await AuthService.updateCurrentUser(updatedUser);
      
      print('DEBUG: Deleted note for trip $tripId');
    } catch (e) {
      print('Error deleting local note: $e');
    }
  }
}
