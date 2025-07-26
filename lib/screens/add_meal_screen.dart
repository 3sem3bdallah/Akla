import 'package:akla/database/db_helper.dart';
import 'package:akla/models/meal_model.dart' show MealModel;
import 'package:akla/widget/custom_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _formKey =
      GlobalKey<FormState>(); // نقلت formKey هنا لأنها يجب أن تكون في الـ State
  final nameController = TextEditingController();
  final imageUrlController = TextEditingController();
  final timeController = TextEditingController();
  final rateController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'title-0'.tr(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomTextField(
                  controller: nameController,
                  labelText: 'meal_name'.tr(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'error-1'.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                CustomTextField(
                  controller: imageUrlController,
                  labelText: 'img_url'.tr(),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'error-2'.tr();
                    }
                    if (!value.startsWith('http://') &&
                        !value.startsWith('https://')) {
                      return 'Please enter a valid URL (start with http:// or https://)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                CustomTextField(
                  controller: timeController,
                  labelText: 'time'.tr(),
                  validator: (value) {
                    if (value == null) {
                      return 'error-3'.tr();
                    }
                    if (value.isEmpty) {
                      return 'error-4'.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                CustomTextField(
                  controller: rateController,
                  labelText: 'Rate'.tr(),
                  keyboardType: TextInputType.number, // أضفت keyboardType
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'error-5'.tr();
                    }
                    final rate = double.tryParse(value);
                    if (rate == null || rate < 0 || rate > 10) {
                      return 'error-6'.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                CustomTextField(
                  controller: descriptionController,
                  labelText: 'Description'.tr(),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'error-7'.tr();
                    }
                    if (value.length < 10) {
                      return 'error-8'.tr();
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final name = nameController.text;
                        final imageUrl = imageUrlController.text;
                        final time = timeController.text;
                        final rate = double.tryParse(rateController.text) ?? 0;
                        final description = descriptionController.text;

                        final newMeal = MealModel(
                          name: name,
                          imageUrl: imageUrl,
                          time: time,
                          rate: rate,
                          description: description,
                        );

                        await DatabaseHelper.instance.insertMeal(newMeal);

                        if (!mounted) return;
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add Meal'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
