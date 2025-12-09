import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../components/bottom_nav_bar.dart';
import '../../components/input_text_field.dart';
import '../../components/place_card.dart';
import '../../constants/text_styles.dart';
import '../../services/places_service.dart';
import '../../services/user_service.dart';

class search extends StatefulWidget {
  const search({super.key});

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  int _selectedIndex = 1;
  
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';
  final TextEditingController _searchController = TextEditingController();
  Set<String> _favorites = {}; // Suivi des favoris

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _favorites = {};
    _searchResults = [];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final results = await PlacesService.searchPlaces(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors de la recherche: $e';
        _isLoading = false;
      });
    }
  }

  void _toggleFavorite(Map<String, dynamic> place) {
    final placeId = place['id'].toString();
    
    if (_favorites.contains(placeId)) {
      // Retirer des favoris
      _favorites.remove(placeId);
      UserService.removeFavorite(place['id']);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Retiré des favoris'),
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      // Ajouter aux favoris
      _favorites.add(placeId);
      UserService.addFavorite({
        'id': place['id'],
        'placeName': place['placeName'],
        'city': place['city'],
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ajouté aux favoris'),
          duration: Duration(seconds: 1),
        ),
      );
    }
    setState(() {});
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

            const Text(
              'Search',
              style: TextStyles.h1,
            ),

            const SizedBox(height: 20),

            InputTextField(
              controller: _searchController,
              hintText: 'Rechercher un lieu...',
              icon: LucideIcons.search,
              iconColor: Colors.blue,
              onChanged: (value) {
                _performSearch(value);
              },
            ),

            const SizedBox(height: 20),

            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (_errorMessage.isNotEmpty)
              Center(
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (_searchResults.isEmpty && _searchController.text.isNotEmpty)
              const Center(
                child: Text('Aucun résultat trouvé'),
              )
            else if (_searchResults.isEmpty)
              const Center(
                child: Text('Tapez pour rechercher des lieux'),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final place = _searchResults[index];
                    final placeId = place['id'].toString();
                    final isFavorite = _favorites.contains(placeId);
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: PlaceCard(
                        title: place['placeName'] ?? 'Lieu inconnu',
                        subtitle: place['city'] ?? 'Ville inconnue',
                        isFavorite: isFavorite,
                        onTap: () {
                          print('Lieu sélectionné: ${place['placeName']}');
                        },
                        onFavoriteToggle: () {
                          _toggleFavorite(place);
                        },
                      ),
                    );
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
