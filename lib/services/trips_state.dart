import 'dart:convert';
import 'package:http/http.dart' as http;

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
      final response = await http.get(Uri.parse('$baseUrl/trips'));
      
      if (response.statusCode == 200) {
        final tripsData = jsonDecode(response.body) as List;
        
        _trips = List<Map<String, dynamic>>.from(
          tripsData.map((trip) => Map<String, dynamic>.from(trip as Map))
        );
        
        print('Loaded ${_trips.length} trips from API');
      } else {
        print('Error loading trips: ${response.statusCode}');
        _trips = [];
      }
    } catch (e) {
      print('Error loading trips: $e');
      _trips = [];
    }
  }

  Future<void> addTrip(Map<String, dynamic> newTrip) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/trips'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newTrip),
      );

      if (response.statusCode == 201) {
        final createdTrip = jsonDecode(response.body) as Map<String, dynamic>;
        _trips.add(createdTrip);
        print('Trip added via API: ${newTrip['destination']}');
        print('Total trips: ${_trips.length}');
      } else {
        print('Error adding trip: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding trip: $e');
    }
  }

  Future<void> deleteTrip(int tripId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/trips/$tripId'),
      );

      if (response.statusCode == 200) {
        _trips.removeWhere((trip) => trip['tripId'] == tripId);
        print('Trip deleted via API with ID: $tripId');
        print('Total trips: ${_trips.length}');
      } else {
        print('Error deleting trip: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting trip: $e');
    }
  }

  void clearAll() {
    _trips.clear();
  }
}
