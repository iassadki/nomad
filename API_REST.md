# Nomad API REST

## Démarrage du serveur

```bash
cd /Users/ilias/IT_Projects/Flutter_Projects/nomad
dart bin/api_server.dart
```

Le serveur sera accessible sur `http://localhost:8080`

## Endpoints disponibles

### Utilisateur

**GET /api/user**
- Récupère les infos utilisateur complètes

```bash
curl http://localhost:8080/api/user
```

### Voyages

**GET /api/trips**
- Récupère tous les voyages

```bash
curl http://localhost:8080/api/trips
```

**POST /api/trips**
- Crée un nouveau voyage

```bash
curl -X POST http://localhost:8080/api/trips \
  -H "Content-Type: application/json" \
  -d '{
    "destination": "Sintra",
    "startDate": "2026-01-10",
    "endDate": "2026-01-15",
    "startingAddress": "Lisbon"
  }'
```

**DELETE /api/trips/:id**
- Supprime un voyage

```bash
curl -X DELETE http://localhost:8080/api/trips/1
```

### Lieux

**GET /api/places**
- Récupère tous les lieux (Porto + Lisboa)

```bash
curl http://localhost:8080/api/places
```

**GET /api/places/:city**
- Récupère les lieux d'une ville spécifique

```bash
curl http://localhost:8080/api/places/porto
curl http://localhost:8080/api/places/lisboa
```

### Favoris

**GET /api/favorites**
- Récupère tous les lieux favoris

```bash
curl http://localhost:8080/api/favorites
```

**POST /api/favorites**
- Ajoute un lieu aux favoris

```bash
curl -X POST http://localhost:8080/api/favorites \
  -H "Content-Type: application/json" \
  -d '{
    "id": 3,
    "placeName": "Livraria Lello",
    "city": "Porto"
  }'
```

**DELETE /api/favorites/:id**
- Retire un lieu des favoris

```bash
curl -X DELETE http://localhost:8080/api/favorites/1
```

## Utilisation dans Flutter

Remplace tes appels locaux par des requêtes HTTP :

```dart
import 'package:http/http.dart' as http;

final response = await http.get(Uri.parse('http://localhost:8080/api/places/porto'));
final data = jsonDecode(response.body);
```

## Notes

- Le serveur utilise la mémoire (les changements ne persistent pas au redémarrage)
- Pour la persistance réelle, connecte à une vraie base de données
- Les ports 8080 doivent être disponibles
