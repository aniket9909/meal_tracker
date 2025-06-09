import 'package:flutter/material.dart';
import 'package:meal_tracker/presentation/screens/meal_entry_screen.dart';
import 'package:meal_tracker/presentation/screens/meal_history_screen.dart';
// import 'screens/meal_entry_screen.dart';
// import 'screens/meal_history_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    MealEntryScreen(),
    MealHistoryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Meal'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}