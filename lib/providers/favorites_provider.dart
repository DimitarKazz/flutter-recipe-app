import 'package:flutter/foundation.dart';
import '../models/favorite_meal.dart';
import '../services/firebase_service.dart';

class FavoritesProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<FavoriteMeal> _favorites = [];
  Set<String> _favoriteIds = {};

  List<FavoriteMeal> get favorites => _favorites;
  int get count => _favorites.length;
  bool isFavorite(String mealId) => _favoriteIds.contains(mealId);

  FavoritesProvider() {
    _loadFavorites();
  }

  void _loadFavorites() {
    _firebaseService.getFavorites().listen((favorites) {
      _favorites = favorites;
      _favoriteIds = favorites.map((f) => f.id).toSet();
      notifyListeners();
    });
  }

  Future<void> toggleFavorite(String id, String name, String thumbnail) async {
    if (_favoriteIds.contains(id)) {
      await _firebaseService.removeFavorite(id);
    } else {
      final meal = FavoriteMeal(
        id: id,
        name: name,
        thumbnail: thumbnail,
        addedAt: DateTime.now(),
      );
      await _firebaseService.addFavorite(meal);
    }
  }
}