import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/meal.dart';
import '../providers/meal_providers.dart';
import '../../utils/image_utils.dart';

class MealEntryScreen extends ConsumerStatefulWidget {
  const MealEntryScreen({super.key});

  @override
  ConsumerState<MealEntryScreen> createState() => _MealEntryScreenState();
}

class _MealEntryScreenState extends ConsumerState<MealEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _type;
  DateTime _date = DateTime.now();
  File? _imageFile;

  final _mealTypes = ['breakfast', 'lunch', 'dinner', 'snack'];

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source, imageQuality: 50);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _saveMeal() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    String? imagePath;
    if (_imageFile != null) {
      imagePath = await ImageUtils.saveImageToLocalDir(_imageFile!);
    }

    final meal = Meal(
      name: _name!,
      type: _type ?? _mealTypes[0],
      date: _date,
      imagePath: imagePath,
    );

    final addMeal = ref.read(addMealProvider);
    await addMeal(meal);
    ref.read(mealsListProvider.notifier).loadMeals();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meal Saved!')),
    );
    setState(() {
      _formKey.currentState!.reset();
      _imageFile = null;
      _date = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Meal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Meal Name'),
                validator: (v) => v == null || v.isEmpty ? 'Enter meal name' : null,
                onSaved: (v) => _name = v,
              ),
              DropdownButtonFormField<String>(
                value: _type ?? _mealTypes[0],
                items: _mealTypes
                    .map((type) => DropdownMenuItem(value: type, child: Text(type.capitalize())))
                    .toList(),
                onChanged: (v) => setState(() => _type = v),
                decoration: const InputDecoration(labelText: 'Meal Type'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Date: ${_date.toString().substring(0, 10)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _date,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => _date = picked);
                  },
                ),
              ),
              if (_imageFile != null)
                Image.file(_imageFile!, height: 200, width: 120, fit: BoxFit.cover),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.photo_camera),
                    label: const Text('Camera'),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveMeal,
                child: const Text('Save Meal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringCap on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}