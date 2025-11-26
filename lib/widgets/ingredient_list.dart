import 'package:flutter/material.dart';
import '../models/ingredient.dart';

class IngredientList extends StatelessWidget {
  final List<Ingredient> ingredients;
  const IngredientList({required this.ingredients, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ingredients
          .map((i) => ListTile(
        title: Text(i.name),
        trailing: Text(i.measure),
      ))
          .toList(),
    );
  }
}