import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onTap;

  const MealCard({required this.meal, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          children: [
            Image.network(meal.thumbnail, height: 100, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(meal.name, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}