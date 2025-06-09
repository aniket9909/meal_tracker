class Meal {
  final int? id;
  final String name;
  final String type; // breakfast, lunch, dinner, snack
  final DateTime date;
  final String? imagePath;

  Meal({
    this.id,
    required this.name,
    required this.type,
    required this.date,
    this.imagePath,
  });
}