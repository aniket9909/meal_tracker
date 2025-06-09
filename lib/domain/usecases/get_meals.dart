import '../entities/meal.dart';
import '../repositories/meal_repository.dart';

class GetMeals {
  final MealRepository repository;
  GetMeals(this.repository);

  Future<List<Meal>> call() async {
    return await repository.getMeals();
  }
}