import '../entities/meal.dart';
import '../repositories/meal_repository.dart';

class AddMeal {
  final MealRepository repository;
  AddMeal(this.repository);

  Future<void> call(Meal meal) async {
    await repository.addMeal(meal);
  }
}