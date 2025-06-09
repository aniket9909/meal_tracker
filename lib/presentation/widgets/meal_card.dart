import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/entities/meal.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  const MealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: meal.imagePath != null
            ? Image.file(File(meal.imagePath!), width: 48, height: 48, fit: BoxFit.cover)
            : const Icon(Icons.fastfood, size: 48),
        title: Text(meal.name),
        subtitle: Text(meal.type.capitalize()),
        trailing: Text(meal.date.toString().substring(0, 10)),
      ),
    );
  }
}

extension StringCap on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}