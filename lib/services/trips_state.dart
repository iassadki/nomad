import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class TripsState {
  static final TripsState _instance = TripsState._internal();
  static const String baseUrl = 'http://localhost:8080/api';
  
  List<Map<String, dynamic>> _trips = [];

  factory TripsState() {
    return _instance;
  }

  TripsState._internal();

  List<Map<String, dynamic>> get trips => _trips;

  Future<void> loadTrips() async {
    try {
      final currentUser = AuthService.currentUser;
      if (currentUser == null) {
        print('Error: No user logged in');
        return;
      }

      // Charger les trips du user courant
      _trips = currentUser.trips;
      print('Loaded ${_trips.length} trips from current user');
    } catch (e) {
      print('Error loading trips: $e');
      _trips = [];
    }
  }

  Future<void> addTrip(Map<String, dynamic> newTrip) async {
    try {
      final currentUser = AuthService.currentUser;
      if (currentUser == null) {
        print('Error: No user logged in');
        return;
      }

      // Générer un ID pour le voyage
      final tripId = currentUser.trips.isEmpty ? 1 : (currentUser.trips.map((t) => t['tripId'] as int? ?? 0).reduce((a, b) => a > b ? a : b) + 1);
      
      final tripWithId = {...newTrip, 'tripId': tripId};
      
      // Ajouter au voyage à la liste du user
      final updatedTrips = [...currentUser.trips, tripWithId];
      final updatedUser = currentUser.copyWith(trips: updatedTrips);
      
      // Mettre à jour le user
      await AuthService.updateCurrentUser(updatedUser);
      
      // Mettre à jour l'état local
      _trips = updatedTrips;
      
      print('Trip added: ${newTrip['destination']}');
      print('Total trips: ${_trips.length}');
    } catch (e) {
      print('Error adding trip: $e');
    }
  }

  Future<void> deleteTrip(int tripId) async {
    try {
      final currentUser = AuthService.currentUser;
      if (currentUser == null) {
        print('Error: No user logged in');
        return;
      }

      // Supprimer le voyage de la liste du user
      final updatedTrips = currentUser.trips.where((trip) => trip['tripId'] != tripId).toList();
      final updatedUser = currentUser.copyWith(trips: updatedTrips);
      
      // Mettre à jour le user
      await AuthService.updateCurrentUser(updatedUser);
      
      // Mettre à jour l'état local
      _trips = updatedTrips;
      
      print('Trip deleted with ID: $tripId');
      print('Total trips: ${_trips.length}');
    } catch (e) {
      print('Error deleting trip: $e');
    }
  }

  void clearAll() {
    _trips.clear();
  }
}
