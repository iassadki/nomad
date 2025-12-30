import 'package:flutter/material.dart';
import '../../components/bottom_nav_bar.dart';
import '../../constants/text_styles.dart';
import '../../components/trip_card.dart';
import '../../components/button_primary.dart';
// import '../../components/floating_button.dart';
import '../../services/user_service.dart';
import '../../services/trips_state.dart';
import '../trip_related/my_trip.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with WidgetsBindingObserver {
  int _selectedIndex = 3;
  String _userName = 'Loading...';
  late TripsState _trips;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    _trips = TripsState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserData();
    _loadTrips();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadTrips();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await UserService.getUser();
      
      if (user != null) {
        print('Username: ${user['username']}');
        if (mounted) {
          setState(() {
            _userName = user['username'] ?? 'Unknown';
          });
        }
      } else {
        print('DEBUG: User is null!');
      }
    } catch (e) {
      print('DEBUG: Error: $e');
    }
  }

  Future<void> _loadTrips() async {
    print('DEBUG: Starting to load trips...');
    await _trips.loadTrips();
    print('DEBUG: Trips loaded: ${_trips.trips.length} trips');
    print('DEBUG: Trips data: ${_trips.trips}');
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _deleteTrip(int tripId) {
    _trips.deleteTrip(tripId);
    _loadTrips();
  }

  void _showDeleteDialog(int tripId, String destination) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Trip?'),
        content: Text('Are you sure you want to delete the trip to $destination?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteTrip(tripId);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            // CustomBackButton(margin: const EdgeInsets.only(top: 10, right: 15)),

            const Text(
              'Profile',
              style: TextStyles.h1,
            ),

            const SizedBox(height: 30),

            const Text('Name', style: TextStyles.h4),
            
            Text(
              _userName,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),

            const SizedBox(height: 40),

            const Text('Trips', style: TextStyles.h4),

            const SizedBox(height: 20),

            // Boucle sur les trips
            if (_trips.trips.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.luggage_outlined,
                        size: 60,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "You don't have a trip yet",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Create one by clicking on +',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _trips.trips.length,
                  itemBuilder: (context, index) {
                    final trip = _trips.trips[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Stack(
                        children: [
                          TripCard(
                            title: trip['destination'] ?? 'Unknown',
                            dateRange: 'From ${trip['startDate']} to ${trip['endDate']}',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => my_trip(trip: trip),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () {
                                _showDeleteDialog(
                                  trip['tripId'] ?? index,
                                  trip['destination'] ?? 'Unknown',
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 16),

            // Bouton plus flottant
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: FloatingButton(
            //     navigationRoute: '/create_trip',
            //   ),
            // ),

            const SizedBox(height: 20),

            // Button primary
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ButtonPrimary(
                label: 'Logout',
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/login');
                },
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ButtonPrimary(
                label: 'Delete Account',
                onPressed: () {
                  // TODO: Implémenter la suppression de compte
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
        context: context,
      ),
    );
  }
}
