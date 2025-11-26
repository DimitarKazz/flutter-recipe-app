import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/ingredient.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  const MealDetailScreen({required this.mealId, Key? key}) : super(key: key);

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
    if (mealData == null) return const Center(child: CircularProgressIndicator());

    final ingredients = getIngredients(mealData!);

    return Scaffold(
      appBar: AppBar(title: Text(mealData!['strMeal'])),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(mealData!['strMealThumb']),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(mealData!['strInstructions'] ?? ''),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: ingredients
                    .map((i) => Text('${i.name}: ${i.measure}'))
                    .toList(),
              ),
            ),
            if (mealData!['strYoutube'] != null && mealData!['strYoutube'] != '')
              Padding(
                padding: EdgeInsets.all(8),
                child: InkWell(
                  child: Text(
                    'Watch on YouTube',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    // You can use url_launcher here
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}