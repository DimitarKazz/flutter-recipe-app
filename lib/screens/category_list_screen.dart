import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';
import 'meals_by_category_screen.dart';
import 'meal_detail_screen.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  List<Category> _categories = [];
  bool _isLoading = true;
  String _search = "";

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);

    final cats = await ApiService.fetchCategories();

    setState(() {
      _categories = cats;
      _isLoading = false;
    });
  }

  void _showRandomMeal() async {
    final randomMeal = await ApiService.fetchRandomMeal();

    if (randomMeal != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MealDetailScreen(mealId: randomMeal['idMeal']),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var filtered = _categories
        .where((c) => c.name.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            tooltip: 'Random Recipe',
            onPressed: _showRandomMeal,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Categories...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (val) => setState(() => _search = val),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                ? Center(
              child: Text(
                _search.isEmpty
                    ? 'No categories found'
                    : 'No results for "$_search"',
                style: const TextStyle(fontSize: 16),
              ),
            )
                : RefreshIndicator(
              onRefresh: _loadCategories,
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return CategoryCard(
                    category: filtered[index],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MealsByCategoryScreen(
                          category: filtered[index].name,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}