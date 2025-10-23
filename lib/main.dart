import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jhvostov_prac_1/app_router.dart';
import 'package:jhvostov_prac_1/features/care_tips/screens/care_tips_screen.dart';
import 'package:jhvostov_prac_1/features/fertilizers/screens/fertilizer_screen.dart';
import 'package:jhvostov_prac_1/features/my_plants/screens/my_plants_screen.dart';
import 'package:jhvostov_prac_1/features/plant/state/plants_container.dart';
import 'package:jhvostov_prac_1/features/watering/screens/watering_screen.dart';
import 'package:jhvostov_prac_1/shared/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(PlantApp());
}

class PlantApp extends StatelessWidget {
  PlantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Мой Сад',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}

class GardenScreen extends StatelessWidget {
  final String _imageUrl = "https://ir.ozone.ru/s3/multimedia-b/6606452423.jpg";

  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Мои растения',
      'icon': Icons.favorite,
      'route': 'my_plants',
    },
    {
      'title': 'Полив',
      'icon': Icons.water_drop,
      'route': 'watering',
    },
    {
      'title': 'Советы',
      'icon': Icons.lightbulb,
      'route': 'care_tips',
    },
    {
      'title': 'Удобрения',
      'icon': Icons.agriculture,
      'route': 'fertilizers',
    },
    {
      'title': 'Состояние растений',
      'icon': Icons.local_florist_rounded,
      'route': 'plant_status',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Мой Сад')),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: menuItems.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: CachedNetworkImage(
                    imageUrl: _imageUrl,
                    progressIndicatorBuilder: (context, url, progress) =>
                    const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 50,
                      ),
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          } else if (index == 1) {
            return Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Text(
                  'Добро пожаловать в Сад!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else {
            final menuIndex = index - 2;
            final item = menuItems[menuIndex];
            return _buildMenuButton(
              context,
              item['title'] as String,
              item['icon'] as IconData,
              item['route'] as String,
            );
          }
        },
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon, String routeName) {
    return Center(
      child: Container(
        width: 250,
        margin: EdgeInsets.all(8),
        child: ElevatedButton.icon(
          onPressed: () {
            context.pushNamed(routeName);
          },
          icon: Icon(icon),
          label: Text(title),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }
}