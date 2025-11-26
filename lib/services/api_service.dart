import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';

class ApiService {
  static const baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  static Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['categories'] != null) {
          return (data['categories'] as List)
              .map((json) => Category.fromJson(json))
              .toList();
        }
      }

      return [];
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  static Future<List<Meal>> fetchMealsByCategory(String category) async {
    try {
      final response =
      await http.get(Uri.parse('$baseUrl/filter.php?c=$category'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['meals'] != null) {
          return (data['meals'] as List)
              .map((json) => Meal.fromJson(json))
              .toList();
        }
      }

      return [];
    } catch (e) {
      print('Error fetching meals: $e');
      return [];
    }
  }

  static Future<List<Meal>> searchMeals(String query) async {
    try {
      final response =
      await http.get(Uri.parse('$baseUrl/search.php?s=$query'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['meals'] != null) {
          return (data['meals'] as List)
              .map((json) => Meal.fromJson(json))
              .toList();
        }
      }

      return [];
    } catch (e) {
      print('Error searching meals: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> fetchMealDetail(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['meals'] != null && data['meals'].isNotEmpty) {
          return data['meals'][0];
        }
      }

      return null;
    } catch (e) {
      print('Error fetching meal detail: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchRandomMeal() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/random.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['meals'] != null && data['meals'].isNotEmpty) {
          return data['meals'][0];
        }
      }

      return null;
    } catch (e) {
      print('Error fetching random meal: $e');
      return null;
    }
  }
}