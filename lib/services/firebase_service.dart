import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/favorite_meal.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _userId = 'user_001';

  CollectionReference get _favoritesCollection =>
      _firestore.collection('users').doc(_userId).collection('favorites');

  Future<void> addFavorite(FavoriteMeal meal) async {
    try {
      await _favoritesCollection.doc(meal.id).set(meal.toMap());
      print('✅ Added to favorites: ${meal.name}');
    } catch (e) {
      print('❌ Error adding favorite: $e');
      rethrow;
    }
  }

  Future<void> removeFavorite(String mealId) async {
    try {
      await _favoritesCollection.doc(mealId).delete();
      print('✅ Removed from favorites: $mealId');
    } catch (e) {
      print('❌ Error removing favorite: $e');
      rethrow;
    }
  }

  Stream<List<FavoriteMeal>> getFavorites() {
    return _favoritesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return FavoriteMeal.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<bool> isFavorite(String mealId) async {
    try {
      final doc = await _favoritesCollection.doc(mealId).get();
      return doc.exists;
    } catch (e) {
      print('❌ Error checking favorite: $e');
      return false;
    }
  }
}
