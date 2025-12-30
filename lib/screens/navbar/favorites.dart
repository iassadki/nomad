import 'package:flutter/material.dart';
import '../../components/bottom_nav_bar.dart';
import '../../components/place_card.dart';
import '../../constants/text_styles.dart';
import '../../services/user_service.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  int _selectedIndex = 2;
  List<dynamic> _favoritesList = [];
  bool _isLoading = true;
  String _errorMessage = '';

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final favorites = await UserService.getUserFavorites();
      setState(() {
        _favoritesList = favorites;
        _isLoading = false;
      });
      print('Loaded ${favorites.length} Favorites');
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du chargement: $e';
        _isLoading = false;
      });
      print('Error loading Favorites: $e');
    }
  }

  Future<void> _removeFavorite(int favoriteId) async {
    try {
      await UserService.removeFavorite(favoriteId);
      setState(() {
        _favoritesList.removeWhere((fav) => fav['id'] == favoriteId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Retiré des favoris'),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  const Text(
                    'Favorites',
                    style: TextStyles.h1,
                  ),
                  const SizedBox(height: 20),
                  if (_errorMessage.isNotEmpty)
                    Center(
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  else if (_favoritesList.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text('Aucun favori pour le moment'),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: _favoritesList.length,
                        itemBuilder: (context, index) {
                          final favorite = _favoritesList[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Stack(
                              children: [
                                PlaceCard(
                                  title: favorite['placeName'] ?? 'Lieu inconnu',
                                  subtitle: favorite['city'] ?? 'Ville inconnue',
                                  isFavorite: true,
                                  onTap: () {
                                    print('Favori sélectionné: ${favorite['placeName']}');
                                  },
                                  onFavoriteToggle: () {
                                    _removeFavorite(favorite['id']);
                                  },
                                ),
                              ],
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
