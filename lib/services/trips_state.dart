import 'dart:convert';
import 'package:flutter/services.dart';

class TripsState {
  static final TripsState _instance = TripsState._internal();
  
  List<Map<String, dynamic>> _trips = [];

  factory TripsState() {
    return _instance;
  }

  TripsState._internal();

  List<Map<String, dynamic>> get trips => _trips;

  Future<void> loadTrips() async {
    try {
      if (_trips.isEmpty) {
        // Charger depuis les assets seulement la première fois
        final String response = await rootBundle.loadString('assets/api/user_data_filled.json');
        final data = json.decode(response);
        final tripsData = data['user']['trips'] ?? [];
        
        _trips = List<Map<String, dynamic>>.from(
          tripsData.map((trip) => Map<String, dynamic>.from(trip as Map))
        );
        
        print('Loaded ${_trips.length} trips from assets');
      }
    } catch (e) {
      print('Error loading trips: $e');
      _trips = [];
    }
  }

  void addTrip(Map<String, dynamic> newTrip) {
    // Générer un ID unique
    final int maxId = _trips.isEmpty
        ? 0
        : _trips.map<int>((trip) => (trip['tripId'] as int?) ?? 0).reduce((a, b) => a > b ? a : b);

    newTrip['tripId'] = maxId + 1;
    _trips.add(newTrip);
    
    print('Trip added: ${newTrip['destination']}');
    print('Total trips: ${_trips.length}');
  }

  void deleteTrip(int tripId) {
    _trips.removeWhere((trip) => trip['tripId'] == tripId);
    print('Trip deleted with ID: $tripId');
    print('Total trips: ${_trips.length}');
  }

  void clearAll() {
    _trips.clear();
  }
}
