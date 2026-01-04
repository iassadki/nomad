import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final server = await HttpServer.bind('localhost', 8080);
  print('API Server running on http://localhost:8080');
  await for (HttpRequest request in server) {
    handleRequest(request);
  }
}

void handleRequest(HttpRequest request) {
  final path = request.uri.path;
  final method = request.method;
  
  // Ajoute les headers CORS
  request.response.headers.add('Access-Control-Allow-Origin', '*');
  request.response.headers.add('Access-Control-Allow-Methods', 'GET, POST, DELETE, OPTIONS');
  request.response.headers.add('Access-Control-Allow-Headers', 'Content-Type');
  request.response.headers.contentType = ContentType.json;

  // Gère les requêtes OPTIONS (CORS preflight)
  if (method == 'OPTIONS') {
    request.response.statusCode = 200;
    request.response.close();
    return;
  }

  if (method == 'GET') {
    if (path == '/api/user') {
      handleGetUser(request);
    } else if (path == '/api/trips') {
      handleGetTrips(request);
    } else if (path == '/api/places') {
      handleGetPlaces(request);
    } else if (path.startsWith('/api/places/')) {
      handleGetPlacesByCity(request);
    } else if (path == '/api/favorites') {
      handleGetFavorites(request);
    } else if (path.startsWith('/api/trips/') && path.endsWith('/notes')) {
      handleGetNote(request);
    } else {
      notFound(request);
    }
  } else if (method == 'POST') {
    if (path == '/api/login') {
      handleLogin(request);
    } else if (path == '/api/trips') {
      handleCreateTrip(request);
    } else if (path == '/api/favorites') {
      handleAddFavorite(request);
    } else if (path.startsWith('/api/trips/') && path.endsWith('/notes')) {
      handleSaveNote(request);
    } else {
      notFound(request);
    }
  } else if (method == 'DELETE') {
    if (path.startsWith('/api/trips/')) {
      handleDeleteTrip(request);
    } else if (path.startsWith('/api/favorites/')) {
      handleRemoveFavorite(request);
    } else {
      notFound(request);
    }
  } else {
    methodNotAllowed(request);
  }
}

void notFound(HttpRequest request) {
  request.response.statusCode = 404;
  request.response.write(jsonEncode({'error': 'Not found'}));
  request.response.close();
}

void methodNotAllowed(HttpRequest request) {
  request.response.statusCode = 405;
  request.response.write(jsonEncode({'error': 'Method not allowed'}));
  request.response.close();
}



// Base de données des utilisateurs
// Map<int, Map<String, dynamic>> usersDatabase = {
//   1: {
//     "id": 1,
//     "username": "c.carvalho",
//     "password": "carvalho123",
//     "email": "carvalho@example.com",
//     "trips": [
//       {
//         "tripId": 1,
//         "destination": "Porto",
//         "startDate": "2025-12-20",
//         "endDate": "2026-01-03"
//       },
//       {
//         "tripId": 2,
//         "destination": "Lisboa",
//         "startDate": "2025-12-20",
//         "endDate": "2026-01-03"
//       }
//     ],
//     "favoritePlaces": [
//       {"id": 1, "placeName": "Ribeira", "city": "Porto"},
//       {"id": 2, "placeName": "Torre de Belém", "city": "Lisboa"}
//     ],
//     "notesOfTheTrip": []
//   },
//   2: {
//     "id": 2,
//     "username": "exampleUser",
//     "password": "examplePassword",
//     "email": "example@example.com",
//     "trips": [
//       {
//         "tripId": 1,
//         "destination": "Porto",
//         "startDate": "2025-12-20",
//         "endDate": "2026-01-03"
//       },
//       {
//         "tripId": 2,
//         "destination": "Lisboa",
//         "startDate": "2025-12-20",
//         "endDate": "2026-01-03"
//       }
//     ],
//     "favoritePlaces": [
//       {"id": 1, "placeName": "Estádio do Dragão", "city": "Porto"},
//       {"id": 2, "placeName": "Praça do Comércio", "city": "Lisboa"}
//     ],
//     "notesOfTheTrip": []
//   }
// };

// Utilisateur actuellement connecté (par session)
int? currentUserId;

Map<String, dynamic> placesData = {
  "cities": {
    "porto": {
      "places": [
        {"id": 1, "placeName": "Ribeira"},
        {"id": 2, "placeName": "Pont Dom-Luís"},
        {"id": 3, "placeName": "Livraria Lello"},
        {"id": 4, "placeName": "Torre dos Clérigos"},
        {"id": 5, "placeName": "Caves de Gaia"},
        {"id": 6, "placeName": "Estádio do Dragão"}
      ]
    },
    "lisboa": {
      "places": [
        {"id": 1, "placeName": "Torre de Belém"},
        {"id": 2, "placeName": "Mosteiro dos Jerónimos"},
        {"id": 3, "placeName": "Castelo de São Jorge"},
        {"id": 4, "placeName": "Azulejo Tradicional"},
        {"id": 5, "placeName": "Praça do Comércio"},
        {"id": 6, "placeName": "Elevador de Santa Justa"},
        {"id": 7, "placeName": "Museu Calouste Gulbenkian"},
        {"id": 8, "placeName": "Bairro Alto"}
      ]
    }
  }
};

void handleGetUser(HttpRequest request) {
  if (currentUserId == null) {
    request.response.statusCode = 401;
    request.response.write(jsonEncode({'error': 'Not authenticated'}));
    request.response.close();
    return;
  }
  
  // final user = usersDatabase[currentUserId];
  // if (user == null) {
  //   request.response.statusCode = 404;
  //   request.response.write(jsonEncode({'error': 'User not found'}));
  //   request.response.close();
  //   return;
  // }
  
  request.response.statusCode = 200;
  request.response.write(jsonEncode({'user': user}));
  request.response.close();
}

void handleLogin(HttpRequest request) {
  StringBuffer buffer = StringBuffer();
  request.listen(
    (List<int> chunk) => buffer.write(utf8.decode(chunk)),
    onDone: () {
      try {
        final data = jsonDecode(buffer.toString());
        final email = data['email'] ?? '';
        final username = data['username'] ?? '';
        final password = data['password'] ?? '';

        print('LOGIN ATTEMPT: email=$email, username=$username, password=$password');

        // Chercher l'utilisateur
        int? userId;
        for (var entry in usersDatabase.entries) {
          final user = entry.value;
          print('Checking user: ${user['username']} with password ${user['password']}');
          if ((user['username'] == username || user['email'] == email) && user['password'] == password) {
            userId = entry.key;
            print('FOUND MATCHING USER: $userId');
            break;
          }
        }

        if (userId == null) {
          print('NO MATCHING USER FOUND');
          request.response.statusCode = 401;
          request.response.write(jsonEncode({'error': 'Invalid credentials'}));
          request.response.close();
          return;
        }

        currentUserId = userId;
        final user = usersDatabase[userId]!;

        print('LOGIN SUCCESS: User $userId connected');
        request.response.statusCode = 200;
        request.response.write(jsonEncode({
          'user': user,
          'token': 'token_$userId',
          'message': 'Login successful'
        }));
        request.response.close();
      } catch (e) {
        print('LOGIN ERROR: $e');
        request.response.statusCode = 400;
        request.response.write(jsonEncode({'error': 'Invalid data: $e'}));
        request.response.close();
      }
    },
  );
}

void handleGetTrips(HttpRequest request) {
  if (currentUserId == null) {
    request.response.statusCode = 401;
    request.response.write(jsonEncode({'error': 'Not authenticated'}));
    request.response.close();
    return;
  }

  final user = usersDatabase[currentUserId];
  if (user == null) {
    request.response.statusCode = 404;
    request.response.write(jsonEncode({'error': 'User not found'}));
    request.response.close();
    return;
  }

  request.response.statusCode = 200;
  request.response.write(jsonEncode(user["trips"]));
  request.response.close();
}

void handleCreateTrip(HttpRequest request) {
  if (currentUserId == null) {
    request.response.statusCode = 401;
    request.response.write(jsonEncode({'error': 'Not authenticated'}));
    request.response.close();
    return;
  }

  StringBuffer buffer = StringBuffer();
  request.listen(
    (List<int> chunk) => buffer.write(utf8.decode(chunk)),
    onDone: () {
      try {
        final user = usersDatabase[currentUserId];
        if (user == null) {
          request.response.statusCode = 404;
          request.response.write(jsonEncode({'error': 'User not found'}));
          request.response.close();
          return;
        }

        final newTrip = jsonDecode(buffer.toString());
        final trips = user["trips"] as List;
        final newId = (trips.isEmpty ? 0 : (trips.map((t) => t["tripId"] as int).reduce((a, b) => a > b ? a : b))) + 1;
        newTrip["tripId"] = newId;
        trips.add(newTrip);
        request.response.statusCode = 201;
        request.response.write(jsonEncode(newTrip));
        request.response.close();
      } catch (e) {
        request.response.statusCode = 400;
        request.response.write(jsonEncode({'error': 'Invalid data'}));
        request.response.close();
      }
    },
  );
}

void handleDeleteTrip(HttpRequest request) {
  if (currentUserId == null) {
    request.response.statusCode = 401;
    request.response.write(jsonEncode({'error': 'Not authenticated'}));
    request.response.close();
    return;
  }

  final id = int.tryParse(request.uri.pathSegments.last);
  if (id == null) {
    request.response.statusCode = 400;
    request.response.write(jsonEncode({'error': 'Invalid ID'}));
    request.response.close();
    return;
  }

  final user = usersDatabase[currentUserId];
  if (user == null) {
    request.response.statusCode = 404;
    request.response.write(jsonEncode({'error': 'User not found'}));
    request.response.close();
    return;
  }

  final trips = user["trips"] as List;
  final index = trips.indexWhere((t) => t["tripId"] == id);
  if (index == -1) {
    request.response.statusCode = 404;
    request.response.write(jsonEncode({'error': 'Not found'}));
    request.response.close();
    return;
  }
  trips.removeAt(index);
  request.response.statusCode = 200;
  request.response.write(jsonEncode({'message': 'Deleted'}));
  request.response.close();
}

void handleGetPlaces(HttpRequest request) {
  request.response.statusCode = 200;
  request.response.write(jsonEncode(placesData));
  request.response.close();
}

void handleGetPlacesByCity(HttpRequest request) {
  final city = request.uri.pathSegments[2].toLowerCase();
  final places = placesData["cities"][city];
  if (places == null) {
    request.response.statusCode = 404;
    request.response.write(jsonEncode({'error': 'Not found'}));
    request.response.close();
    return;
  }
  request.response.statusCode = 200;
  request.response.write(jsonEncode(places));
  request.response.close();
}

void handleGetNote(HttpRequest request) {
  if (currentUserId == null) {
    request.response.statusCode = 401;
    request.response.write(jsonEncode({'error': 'Not authenticated'}));
    request.response.close();
    return;
  }

  final pathSegments = request.uri.pathSegments;
  final tripId = int.tryParse(pathSegments[2]);
  
  if (tripId == null) {
    request.response.statusCode = 400;
    request.response.write(jsonEncode({'error': 'Invalid trip ID'}));
    request.response.close();
    return;
  }

  final user = usersDatabase[currentUserId];
  if (user == null) {
    request.response.statusCode = 404;
    request.response.write(jsonEncode({'error': 'User not found'}));
    request.response.close();
    return;
  }

  // Pour maintenant, les notes sont stockées localement (SharedPreferences)
  // Cette endpoint est juste un placeholder
  request.response.statusCode = 404;
  request.response.write(jsonEncode({'error': 'Not found'}));
  request.response.close();
}

void handleSaveNote(HttpRequest request) {
  if (currentUserId == null) {
    request.response.statusCode = 401;
    request.response.write(jsonEncode({'error': 'Not authenticated'}));
    request.response.close();
    return;
  }

  final pathSegments = request.uri.pathSegments;
  final tripId = int.tryParse(pathSegments[2]);
  
  if (tripId == null) {
    request.response.statusCode = 400;
    request.response.write(jsonEncode({'error': 'Invalid trip ID'}));
    request.response.close();
    return;
  }

  StringBuffer buffer = StringBuffer();
  request.listen(
    (List<int> chunk) => buffer.write(utf8.decode(chunk)),
    onDone: () {
      try {
        final user = usersDatabase[currentUserId];
        if (user == null) {
          request.response.statusCode = 404;
          request.response.write(jsonEncode({'error': 'User not found'}));
          request.response.close();
          return;
        }

        final noteData = jsonDecode(buffer.toString());
        
        // Pour maintenant, on retourne juste un succès
        // Les notes sont stockées localement (SharedPreferences)
        request.response.statusCode = 200;
        request.response.write(jsonEncode({'message': 'Note saved', 'noteText': noteData['noteText']}));
        request.response.close();
      } catch (e) {
        request.response.statusCode = 400;
        request.response.write(jsonEncode({'error': 'Invalid data'}));
        request.response.close();
      }
    },
  );
}

void handleGetFavorites(HttpRequest request) {
  if (currentUserId == null) {
    request.response.statusCode = 401;
    request.response.write(jsonEncode({'error': 'Not authenticated'}));
    request.response.close();
    return;
  }

  final user = usersDatabase[currentUserId];
  if (user == null) {
    request.response.statusCode = 404;
    request.response.write(jsonEncode({'error': 'User not found'}));
    request.response.close();
    return;
  }

  request.response.statusCode = 200;
  request.response.write(jsonEncode(user["favoritePlaces"]));
  request.response.close();
}

void handleAddFavorite(HttpRequest request) {
  if (currentUserId == null) {
    request.response.statusCode = 401;
    request.response.write(jsonEncode({'error': 'Not authenticated'}));
    request.response.close();
    return;
  }

  StringBuffer buffer = StringBuffer();
  request.listen(
    (List<int> chunk) => buffer.write(utf8.decode(chunk)),
    onDone: () {
      try {
        final user = usersDatabase[currentUserId];
        if (user == null) {
          request.response.statusCode = 404;
          request.response.write(jsonEncode({'error': 'User not found'}));
          request.response.close();
          return;
        }

        final newFavorite = jsonDecode(buffer.toString());
        final favorites = user["favoritePlaces"] as List;
        favorites.add(newFavorite);
        request.response.statusCode = 201;
        request.response.write(jsonEncode(newFavorite));
        request.response.close();
      } catch (e) {
        request.response.statusCode = 400;
        request.response.write(jsonEncode({'error': 'Invalid data'}));
        request.response.close();
      }
    },
  );
}

void handleRemoveFavorite(HttpRequest request) {
  if (currentUserId == null) {
    request.response.statusCode = 401;
    request.response.write(jsonEncode({'error': 'Not authenticated'}));
    request.response.close();
    return;
  }

  final id = int.tryParse(request.uri.pathSegments.last);
  if (id == null) {
    request.response.statusCode = 400;
    request.response.write(jsonEncode({'error': 'Invalid ID'}));
    request.response.close();
    return;
  }

  final user = usersDatabase[currentUserId];
  if (user == null) {
    request.response.statusCode = 404;
    request.response.write(jsonEncode({'error': 'User not found'}));
    request.response.close();
    return;
  }

  final favorites = user["favoritePlaces"] as List;
  final index = favorites.indexWhere((f) => f["id"] == id);
  if (index == -1) {
    request.response.statusCode = 404;
    request.response.write(jsonEncode({'error': 'Not found'}));
    request.response.close();
    return;
  }
  favorites.removeAt(index);
  request.response.statusCode = 200;
  request.response.write(jsonEncode({'message': 'Deleted'}));
  request.response.close();
}
