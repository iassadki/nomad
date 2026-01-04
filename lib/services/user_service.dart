import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class UserService {
  static const String baseUrl = 'http://localhost:8080/api';

  static Future<List<dynamic>> getUserFavorites() async {
    try {
      final currentUser = AuthService.currentUser;
      if (currentUser == null) {
        print('Error: No user logged in');
        return [];
      }

      print('Loaded ${currentUser.favorites.length} user favorites');
      return currentUser.favorites;
    } catch (e) {
      print('Error loading favorites: $e');
      return [];
    }
  }

  static Future<void> removeFavorite(int favoriteId) async {
    try {
      final currentUser = AuthService.currentUser;
      if (currentUser == null) {
        print('Error: No user logged in');
        return;
      }

      // Retirer le favori de la liste
      final updatedFavorites = currentUser.favorites.where((fav) => fav['id'] != favoriteId).toList();
      final updatedUser = currentUser.copyWith(favorites: updatedFavorites);
      
      // Mettre à jour le user
      await AuthService.updateCurrentUser(updatedUser);
      
      print('Favorite $favoriteId removed successfully');
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

  static Future<void> addFavorite(Map<String, dynamic> favorite) async {
    try {
      final currentUser = AuthService.currentUser;
      if (currentUser == null) {
        print('Error: No user logged in');
        return;
      }

      // Ajouter le favori à la liste
      final updatedFavorites = [...currentUser.favorites, favorite];
      final updatedUser = currentUser.copyWith(favorites: updatedFavorites);
      
      // Mettre à jour le user
      await AuthService.updateCurrentUser(updatedUser);
      
      print('Favorite added successfully');
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }
}
