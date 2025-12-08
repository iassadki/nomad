import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TripService {
  static const String _tripsKey = 'trips_data';

  // Charger les trips depuis le fichier JSON initial
  static Future<List<dynamic>> loadTripsFromAssets() async {
    try {
      final String response =
          await rootBundle.loadString('assets/api/user_data_filled.json');
      final data = json.decode(response);
      final trips = data['user']['trips'] ?? [];
      print('Trips chargés depuis assets: ${trips.length} trips');
      print('Data: $trips');
      return trips;
    } catch (e) {
      print('Erreur lors du chargement des trips: $e');
      return [];
    }
  }

  // Sauvegarder les trips en local
  static Future<void> saveTrips(List<dynamic> trips) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tripsJson = json.encode(trips);
      print('=== saveTrips() ===');
      print('Saving ${trips.length} trips to SharedPreferences');
      print('JSON length: ${tripsJson.length} chars');
      
      final success = await prefs.setString(_tripsKey, tripsJson);
      print('Save success: $success');
      
      if (success) {
        // Vérifier qu'on a bien sauvegardé
        final saved = prefs.getString(_tripsKey);
        print('Verification - Saved data length: ${saved?.length}');
      }
    } catch (e) {
      print('Erreur lors de la sauvegarde des trips: $e');
    }
  }

  // Récupérer les trips sauvegardés
  static Future<List<dynamic>> getTrips() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tripsJson = prefs.getString(_tripsKey);

      print('=== getTrips() ===');
      print('Checking SharedPreferences for key: $_tripsKey');

      if (tripsJson == null) {
        print('No trips in SharedPreferences, loading from assets');
        // Si aucun trip sauvegardé, charger depuis les assets
        final trips = await loadTripsFromAssets();
        print('Loaded ${trips.length} trips from assets');
        
        // Assurer que chaque trip a un tripId
        for (int i = 0; i < trips.length; i++) {
          if (trips[i]['tripId'] == null) {
            trips[i]['tripId'] = i + 1;
          }
        }
        
        print('Saving ${trips.length} trips to SharedPreferences');
        await saveTrips(trips);
        return trips;
      }

      print('Found trips in SharedPreferences');
      final decodedTrips = json.decode(tripsJson) as List<dynamic>;
      print('Decoded ${decodedTrips.length} trips from JSON');
      print('Trips data: $decodedTrips');
      
      // Assurer que chaque trip a un tripId
      for (int i = 0; i < decodedTrips.length; i++) {
        if (decodedTrips[i]['tripId'] == null) {
          decodedTrips[i]['tripId'] = i + 1;
        }
      }
      
      return decodedTrips;
    } catch (e) {
      print('Erreur lors du chargement des trips: $e');
      return [];
    }
  }

  // Ajouter un nouveau trip
  static Future<void> addTrip(Map<String, dynamic> newTrip) async {
    try {
      print('=== addTrip() ===');
      print('Adding trip: ${newTrip['destination']}');
      
      final trips = await getTrips();
      print('Current trips count: ${trips.length}');

      // Convertir les trips en List<Map<String, dynamic>> pour éviter les soucis JSON
      final tripsList = List<Map<String, dynamic>>.from(
        trips.map((trip) {
          if (trip is Map) {
            return Map<String, dynamic>.from(trip as Map);
          }
          return trip as Map<String, dynamic>;
        })
      );

      // Générer un ID unique
      final int maxId = tripsList.isEmpty
          ? 0
          : (tripsList
              .map<int>((trip) => (trip['tripId'] as int?) ?? 0)
              .reduce((a, b) => a > b ? a : b));

      final newId = maxId + 1;
      newTrip['tripId'] = newId;

      tripsList.add(newTrip);
      
      print('New trip added with ID: $newId');
      print('Total trips before save: ${tripsList.length}');
      
      await saveTrips(tripsList);

      print('Trip added successfully');
    } catch (e) {
      print('Erreur lors de l\'ajout du trip: $e');
      print(e);
    }
  }

  // Supprimer un trip
  static Future<void> deleteTrip(int tripId) async {
    try {
      final trips = await getTrips();
      print('Avant suppression - nombre de trips: ${trips.length}');
      print('Suppression du trip avec ID: $tripId');
      
      trips.removeWhere((trip) {
        final id = trip['tripId'];
        print('Comparaison: $id == $tripId? ${id == tripId}');
        return id == tripId;
      });
      
      print('Après suppression - nombre de trips: ${trips.length}');
      await saveTrips(trips);
      print('Trip supprimé avec succès (ID: $tripId)');
    } catch (e) {
      print('Erreur lors de la suppression du trip: $e');
    }
  }

  // Mettre à jour un trip
  static Future<void> updateTrip(int tripId, Map<String, dynamic> updatedData) async {
    try {
      final trips = await getTrips();
      final index = trips.indexWhere((trip) => trip['tripId'] == tripId);

      if (index != -1) {
        trips[index].addAll(updatedData);
        await saveTrips(trips);
        print('Trip mis à jour avec succès (ID: $tripId)');
      }
    } catch (e) {
      print('Erreur lors de la mise à jour du trip: $e');
    }
  }
}
