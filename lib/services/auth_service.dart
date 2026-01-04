import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String username;
  final String password;
  final List<Map<String, dynamic>> trips;
  final List<Map<String, dynamic>> favorites;
  final Map<int, String> notes; // tripId -> noteText

  User({
    required this.username,
    required this.password,
    this.trips = const [],
    this.favorites = const [],
    this.notes = const {},
  });

  // Convertir en JSON pour le stockage
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'trips': trips,
      'favorites': favorites,
      'notes': notes,
    };
  }

  // Créer un User depuis JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String,
      password: json['password'] as String,
      trips: List<Map<String, dynamic>>.from(json['trips'] as List? ?? []),
      favorites: List<Map<String, dynamic>>.from(json['favorites'] as List? ?? []),
      notes: Map<int, String>.from(
        (json['notes'] as Map?)?.map((k, v) => MapEntry(int.parse(k.toString()), v as String)) ?? {}
      ),
    );
  }

  // Créer une copie avec modifications
  User copyWith({
    String? username,
    String? password,
    List<Map<String, dynamic>>? trips,
    List<Map<String, dynamic>>? favorites,
    Map<int, String>? notes,
  }) {
    return User(
      username: username ?? this.username,
      password: password ?? this.password,
      trips: trips ?? this.trips,
      favorites: favorites ?? this.favorites,
      notes: notes ?? this.notes,
    );
  }
}

class AuthService {
  static const String _usersKey = 'nomad_users';
  static const String _currentUserKey = 'nomad_current_user';

  static User? _currentUser;

  // Récupérer l'utilisateur connecté
  static User? get currentUser => _currentUser;

  // Initialiser le service (charger le current user au démarrage)
  static Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentUsername = prefs.getString(_currentUserKey);
      
      if (currentUsername != null) {
        final user = await getUserByUsername(currentUsername);
        if (user != null) {
          _currentUser = user;
          print('DEBUG: Current user loaded: $currentUsername');
        } else {
          // L'utilisateur stocké n'existe plus, déconnecter
          await logout();
        }
      }
    } catch (e) {
      print('Error initializing auth: $e');
    }
  }

  // Créer un nouvel utilisateur
  static Future<bool> createUser(String username, String password) async {
    try {
      if (username.isEmpty || password.isEmpty) {
        print('Error: Username and password cannot be empty');
        return false;
      }

      // Vérifier si l'utilisateur existe déjà
      final existingUser = await getUserByUsername(username);
      if (existingUser != null) {
        print('Error: User $username already exists');
        return false;
      }

      final prefs = await SharedPreferences.getInstance();
      
      // Récupérer la liste des users
      final usersJson = prefs.getString(_usersKey);
      List<Map<String, dynamic>> users = [];
      
      if (usersJson != null) {
        final decoded = jsonDecode(usersJson) as List;
        users = List<Map<String, dynamic>>.from(decoded);
      }

      // Créer le nouvel utilisateur
      final newUser = User(
        username: username,
        password: password,
        trips: [],
        favorites: [],
        notes: {},
      );

      // Ajouter à la liste
      users.add(newUser.toJson());

      // Sauvegarder
      await prefs.setString(_usersKey, jsonEncode(users));
      
      print('DEBUG: User created: $username');
      return true;
    } catch (e) {
      print('Error creating user: $e');
      return false;
    }
  }

  // Se connecter
  static Future<bool> login(String username, String password) async {
    try {
      final user = await getUserByUsername(username);
      
      if (user == null) {
        print('Error: User not found');
        return false;
      }

      if (user.password != password) {
        print('Error: Invalid password');
        return false;
      }

      // Sauvegarder l'utilisateur connecté
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentUserKey, username);
      
      _currentUser = user;
      print('DEBUG: User logged in: $username');
      return true;
    } catch (e) {
      print('Error logging in: $e');
      return false;
    }
  }

  // Se déconnecter
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentUserKey);
      _currentUser = null;
      print('DEBUG: User logged out');
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  // Récupérer un utilisateur par username
  static Future<User?> getUserByUsername(String username) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey);
      
      if (usersJson == null) return null;

      final decoded = jsonDecode(usersJson) as List;
      final userMap = decoded.firstWhere(
        (user) => user['username'] == username,
        orElse: () => null,
      );

      if (userMap == null) return null;

      return User.fromJson(userMap as Map<String, dynamic>);
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Mettre à jour le current user
  static Future<void> updateCurrentUser(User updatedUser) async {
    try {
      if (_currentUser == null) {
        print('Error: No current user');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_usersKey);
      
      if (usersJson == null) return;

      final decoded = jsonDecode(usersJson) as List;
      final userIndex = decoded.indexWhere(
        (user) => user['username'] == _currentUser!.username,
      );

      if (userIndex == -1) return;

      // Remplacer l'utilisateur
      decoded[userIndex] = updatedUser.toJson();

      // Sauvegarder
      await prefs.setString(_usersKey, jsonEncode(decoded));
      
      // Mettre à jour le current user
      _currentUser = updatedUser;
      
      print('DEBUG: Current user updated: ${updatedUser.username}');
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  // Vérifier s'il y a un utilisateur connecté
  static bool isLoggedIn() {
    return _currentUser != null;
  }
}
