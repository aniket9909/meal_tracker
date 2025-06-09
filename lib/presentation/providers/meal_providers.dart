import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/meal_local_datasource.dart';
import '../../data/repositories/meal_repository_impl.dart';
import '../../domain/usecases/add_meal.dart';
import '../../domain/usecases/get_meals.dart';
import '../../domain/usecases/search_meals.dart';
import '../../domain/usecases/delete_meal.dart';
import '../../domain/entities/meal.dart';

final mealLocalDataSourceProvider = Provider((ref) => MealLocalDataSource());
final mealRepositoryProvider = Provider(
  (ref) => MealRepositoryImpl(ref.read(mealLocalDataSourceProvider)),
);

final getMealsProvider = Provider((ref) => GetMeals(ref.read(mealRepositoryProvider)));
final addMealProvider = Provider((ref) => AddMeal(ref.read(mealRepositoryProvider)));
final searchMealsProvider = Provider((ref) => SearchMeals(ref.read(mealRepositoryProvider)));
final deleteMealProvider = Provider((ref) => DeleteMeal(ref.read(mealRepositoryProvider)));

final mealsListProvider = StateNotifierProvider<MealsNotifier, List<Meal>>((ref) {
  return MealsNotifier(
    getMeals: ref.read(getMealsProvider),
    searchMeals: ref.read(searchMealsProvider),
  );
});

class MealsNotifier extends StateNotifier<List<Meal>> {
  final GetMeals getMeals;
  final SearchMeals searchMeals;
  MealsNotifier({required this.getMeals, required this.searchMeals}) : super([]) {
    loadMeals();
  }

  Future<void> loadMeals() async {
    final meals = await getMeals();
    state = meals;
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      await loadMeals();
    } else {
      state = await searchMeals(query);
    }
  }
}