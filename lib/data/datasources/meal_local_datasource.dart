import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/meal_model.dart';

class MealLocalDataSource {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'meals.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE meals(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            type TEXT,
            date TEXT,
            imagePath TEXT
          )
        ''');
        // Pre-populate data
        await db.insert('meals', {
          'name': 'Oatmeal',
          'type': 'breakfast',
          'date': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
          'imagePath': null,
        });
        await db.insert('meals', {
          'name': 'Chicken Salad',
          'type': 'lunch',
          'date': DateTime.now().toIso8601String(),
          'imagePath': null,
        });
      },
      version: 1,
    );
  }

  Future<void> insertMeal(MealModel meal) async {
    final db = await database;
    await db.insert('meals', meal.toMap());
  }

  Future<List<MealModel>> getAllMeals() async {
    final db = await database;
    final result = await db.query('meals', orderBy: 'date DESC');
    return result.map((e) => MealModel.fromMap(e)).toList();
  }

  Future<List<MealModel>> searchMeals(String query) async {
    final db = await database;
    final result = await db.query(
      'meals',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'date DESC',
    );
    return result.map((e) => MealModel.fromMap(e)).toList();
  }

  Future<void> deleteMeal(int id) async {
    final db = await database;
    await db.delete('meals', where: 'id = ?', whereArgs: [id]);
  }
}