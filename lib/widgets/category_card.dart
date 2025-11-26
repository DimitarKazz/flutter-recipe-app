import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryCard({required this.category, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(category.thumbnail, width: 60, height: 60),
        title: Text(category.name),
        subtitle: Text(
          category.description.length > 60
              ? category.description.substring(0, 60) + '...'
              : category.description,
          maxLines: 2,
        ),
        onTap: onTap,
      ),
    );
  }
}