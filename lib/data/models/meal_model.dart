import '../../domain/entities/meal.dart';

class MealModel extends Meal {
  MealModel({
    int? id,
    required String name,
    required String type,
    required DateTime date,
    String? imagePath,
  }) : super(
          id: id,
          name: name,
          type: type,
          date: date,
          imagePath: imagePath,
        );

  factory MealModel.fromMap(Map<String, dynamic> map) {
    return MealModel(
      id: map['id'] as int?,
      name: map['name'],
      type: map['type'],
      date: DateTime.parse(map['date']),
      imagePath: map['imagePath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'date': date.toIso8601String(),
      'imagePath': imagePath,
    };
  }
}