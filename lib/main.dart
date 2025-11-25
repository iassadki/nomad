import 'package:flutter/material.dart';
import 'screens/account_and_login/login.dart';
import 'screens/trips_list.dart';
import 'screens/my_trip.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation (no routes)',
      routes: {
        '/': (context) => const Login(),
        '/login': (context) => const Login(),
        '/trips_list': (context) => const trips_list(),
        '/my_trip': (context) => const my_trip(),
      },
      initialRoute: '/',
    ); // MaterialApp
  }
}
