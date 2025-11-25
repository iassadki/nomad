import 'package:flutter/material.dart';
import 'screens/account_and_login/login.dart';
import 'screens/trips.dart';
import 'screens/my_trip.dart';
import 'screens/search.dart';
import 'screens/favorites.dart';
import 'screens/profile.dart';

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
        page = const trips();
        break;
      case '/search':
        page = const search();
        break;
      case '/favorites':
        page = const favorites();
        break;
      case '/profile':
        page = const profile();
        break;
      case '/my_trip':
        page = const my_trip();
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
