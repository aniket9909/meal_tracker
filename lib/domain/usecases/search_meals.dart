import '../entities/meal.dart';
import '../repositories/meal_repository.dart';

class SearchMeals {
  final MealRepository repository;
  SearchMeals(this.repository);

  Future<List<Meal>> call(String query) async {
    return await repository.searchMeals(query);
  }
}