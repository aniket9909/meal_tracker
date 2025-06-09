import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/meal_providers.dart';
import '../widgets/meal_card.dart';

class MealHistoryScreen extends ConsumerWidget {
  const MealHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meals = ref.watch(mealsListProvider);

    // Group meals by date
    final groupedMeals = <String, List>{};
    for (final meal in meals) {
      final dateStr = DateFormat('yyyy-MM-dd').format(meal.date);
      groupedMeals.putIfAbsent(dateStr, () => []).add(meal);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(mealsListProvider.notifier).loadMeals(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search meals...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => ref.read(mealsListProvider.notifier).search(v),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref.read(mealsListProvider.notifier).loadMeals(),
              child: ListView(
                children: groupedMeals.entries.map((entry) {
                  final date = entry.key;
                  final meals = entry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          date,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      ...meals.map<Widget>((meal) => MealCard(meal: meal)).toList(),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}