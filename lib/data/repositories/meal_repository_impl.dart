import '../../domain/entities/meal.dart';
import '../../domain/repositories/meal_repository.dart';
import '../datasources/meal_local_datasource.dart';
import '../models/meal_model.dart';

class MealRepositoryImpl implements MealRepository {
  final MealLocalDataSource localDataSource;
  MealRepositoryImpl(this.localDataSource);

  @override
  Future<void> addMeal(Meal meal) async {
    final model = MealModel(
      name: meal.name,
      type: meal.type,
      date: meal.date,
      imagePath: meal.imagePath,
    );
    await localDataSource.insertMeal(model);
  }

  @override
  Future<List<Meal>> getMeals() async {
    return await localDataSource.getAllMeals();
  }

  @override
  Future<List<Meal>> searchMeals(String query) async {
    return await localDataSource.searchMeals(query);
  }

  @override
  Future<void> deleteMeal(int id) async {
    await localDataSource.deleteMeal(id);
  }
}