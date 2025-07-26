import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:akla/models/meal_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Initialize database if not already initialized
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'meals.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE meals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        imageUrl TEXT,
        name TEXT,
        description TEXT,
        rate REAL,
        time TEXT
      )
    ''');
  }

  Future<int> insertMeal(MealModel meal) async {
    Map<String, dynamic> mealMap = meal.toMap();
    final db = await database;
    return await db.insert('meals', mealMap);
  }

  Future<List<MealModel>> getMeals() async {
    final db = await database;
    try {
      final mealsJson = await db.query('meals');
      return mealsJson.map((mealJson) => MealModel.fromMap(mealJson)).toList();
    } catch (e) {
      debugPrint('Database error: $e');
      return []; // Return empty list instead of crashing
    }
  }

  // Add this method to delete all meals
  Future<int> deleteAllMeals() async {
    final db = await database;
    return await db.delete('meals');
  }

  // Add this method to delete a meal by name
  Future<int> deleteMealByName(String name) async {
    final db = await database;
    return await db.delete(
      'meals',
      where: 'name = ?',
      whereArgs: [name],
    );
  }
}
