import 'package:flutter/material.dart';
import 'screens/category_list_screen.dart';
import 'screens/meals_by_category_screen.dart';
import 'screens/meal_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipes',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: {
        '/': (context) => CategoryListScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/meal-detail') {
          final mealId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => MealDetailScreen(mealId: mealId),
          );
        }
        return null;
      },
    );
  }
}