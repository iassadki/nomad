import 'package:flutter/material.dart';
import 'screens/account_and_login/login.dart';
import 'screens/navbar/trips.dart';
import 'screens/trip_related/my_trip.dart';
import 'screens/navbar/search.dart';
import 'screens/navbar/favorites.dart';
import 'screens/navbar/profile.dart';
import 'screens/trip_related/create_trip.dart';
import 'screens/trip_related/map.dart' as map_page;

void main() => runApp(const MyApp());

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
        page = const Login();
        break;
      case '/login':
        page = const Login();
        break;
      case '/trips':
        page = const Trips();
        break;
      case '/search':
        page = const Search();
        break;
      case '/favorites':
        page = const Favorites();
        break;
      case '/profile':
        page = const Profile();
        break;
      case '/my_trip':
        page = const my_trip();
        break;
      case '/create_trip':
        page = const CreateTrip();
        break;
      case '/map':
        page = const map_page.MapPage();
        break;
      default:
        page = const Login();
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
