import 'package:akla/database/db_helper.dart';
import 'package:akla/localization/localization_setup.dart';
import 'package:akla/models/meal_model.dart';
import 'package:akla/screens/add_meal_screen.dart';
import 'package:akla/screens/meal_deatails_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbHelper = DatabaseHelper.instance;
  late Future<List<MealModel>> _mealsFuture;

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  void _loadMeals() {
    setState(() {
      _mealsFuture = dbHelper.getMeals();
    });
  }

  Future<void> _deleteAllMeals() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('msg-1'.tr()),
        content: Text('msg-2'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'yes'.tr(),
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await dbHelper.deleteAllMeals();
      _loadMeals();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('msg-3'..tr())),
      );
    }
  }

  Future<void> _deleteMealByName(String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('msg-1'.tr()),
        content: Text('msg-4'.tr(args: [name])),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('no'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'yes'.tr(),
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await dbHelper.deleteMealByName(name);
      _loadMeals();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"$name" done'.tr())),
      );
    }
  }

  Widget _buildMealCard(MealModel meal, BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealDetailScreen(meal: meal),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: meal.imageUrl,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => _deleteMealByName(meal.name),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              meal.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 18),
                Text('${meal.rate}'),
                const Spacer(),
                const Icon(Icons.access_time_filled,
                    color: Colors.orange, size: 18),
                Text(meal.time),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealGrid(List<MealModel> meals) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: meals.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) => _buildMealCard(meals[index], context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/img/home.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 70,
                  child: Text(
                    'title'.tr(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Your Food'.tr(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FutureBuilder<List<MealModel>>(
                future: _mealsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Lottie.asset('assets/animations/Lonely404.json'),
                    );
                  }
                  return _buildMealGrid(snapshot.data!);
                },
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              LocalizationHelper.changeLanguage(context);
            },
            backgroundColor: Colors.blue,
            heroTag: 'language_button'.tr(),
            tooltip: 'changeLanguage'.tr(),
            child: const Icon(Icons.language, size: 30),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            onPressed: _deleteAllMeals,
            backgroundColor: Colors.red,
            heroTag: 'delete_button'.tr(),
            tooltip: 'deleteAllMeals'.tr(),
            child: const Icon(Icons.delete_forever, size: 30),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddMealScreen(),
                ),
              );
              if (mounted) _loadMeals();
            },
            backgroundColor: Colors.orange,
            heroTag: 'add_button'.tr(),
            tooltip: 'addNew'.tr(),
            child: const Icon(Icons.add, size: 30),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
