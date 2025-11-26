import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/meal_card.dart';
import '../models/meal.dart';
import 'meal_detail_screen.dart';

class MealsByCategoryScreen extends StatefulWidget {
  final String category;
  const MealsByCategoryScreen({required this.category, Key? key}) : super(key: key);

  @override
  State<MealsByCategoryScreen> createState() => _MealsByCategoryScreenState();
}

class _MealsByCategoryScreenState extends State<MealsByCategoryScreen> {
  List<Meal> _meals = [];
  String _search = "";

  @override
  void initState() {
    super.initState();
    ApiService.fetchMealsByCategory(widget.category).then((meals) {
      setState(() => _meals = meals);
    });
  }

  void _searchMeals(String query) async {
    if (query.isEmpty) {
      final allMeals = await ApiService.fetchMealsByCategory(widget.category);
      setState(() => _meals = allMeals);
    } else {
      final results = await ApiService.searchMeals(query);
      // Filter only by models for relevant results
      setState(() => _meals = results.where((m) => m.name.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    var filtered = _meals;

    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(hintText: 'Search Meals'),
              onChanged: (val) => _searchMeals(val),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: filtered
                  .map((meal) => MealCard(
                meal: meal,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MealDetailScreen(mealId: meal.id),
                  ),
                ),
              ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}