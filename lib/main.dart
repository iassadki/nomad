import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/create_user.dart';
import 'screens/navbar/profile.dart';
import 'screens/navbar/search.dart';
import 'screens/navbar/favorites.dart';
import 'screens/navbar/trips.dart';
import 'screens/trip_related/my_trip.dart';
import 'screens/trip_related/create_trip.dart';
import 'screens/trip_related/map.dart' as map_page;
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Route<dynamic> _buildRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case '/':
        page = AuthService.isLoggedIn() ? Profile() : Login();
        break;
      case '/login':
        page = Login();
        break;
      case '/create_user':
        page = CreateUser();
        break;
      case '/profile':
        page = Profile();
        break;
      case '/search':
        page = Search();
        break;
      case '/favorites':
        page = Favorites();
        break;
      case '/my_trip':
        page = my_trip();
        break;
      case '/trips':
        page = Trips();
        break;
      case '/create_trip':
        page = CreateTrip();
        break;
      case '/map':
        page = map_page.MapPage();
        break;
      default:
        page = Login();
    }

    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nomad',
      onGenerateRoute: _buildRoute,
      initialRoute: '/',
    );
  }
}
