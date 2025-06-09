import '../entities/meal.dart';

abstract class MealRepository {
  Future<void> addMeal(Meal meal);
  Future<List<Meal>> getMeals();
  Future<List<Meal>> searchMeals(String query);
  Future<void> deleteMeal(int id);
}