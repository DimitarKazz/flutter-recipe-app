import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/ingredient.dart';
import '../providers/favorites_provider.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  const MealDetailScreen({required this.mealId, super.key});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  Map<String, dynamic>? mealData;

  @override
  void initState() {
    super.initState();
    ApiService.fetchMealDetail(widget.mealId).then((data) {
      setState(() => mealData = data);
    });
  }

  List<Ingredient> getIngredients(Map<String, dynamic> meal) {
    List<Ingredient> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final name = meal['strIngredient$i'];
      final measure = meal['strMeasure$i'];
      if (name != null && name != '' && measure != null && measure != '') {
        ingredients.add(Ingredient(name: name, measure: measure));
      }
    }
    return ingredients;
  }

  @override
  Widget build(BuildContext context) {
    if (mealData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final ingredients = getIngredients(mealData!);

    return Scaffold(
      appBar: AppBar(
        title: Text(mealData!['strMeal']),
        backgroundColor: Colors.green,
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, provider, child) {
              final isFav = provider.isFavorite(widget.mealId);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  provider.toggleFavorite(
                    widget.mealId,
                    mealData!['strMeal'],
                    mealData!['strMealThumb'],
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFav ? 'Removed from favorites' : 'Added to favorites',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              mealData!['strMealThumb'],
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mealData!['strMeal'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Instructions:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(mealData!['strInstructions'] ?? ''),
                  const SizedBox(height: 16),
                  const Text(
                    'Ingredients:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...ingredients.map((i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Text('${i.name}: ${i.measure}'),
                      ],
                    ),
                  )),
                  if (mealData!['strYoutube'] != null &&
                      mealData!['strYoutube'] != '')
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Watch on YouTube'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('YouTube: ${mealData!['strYoutube']}'),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}