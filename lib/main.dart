import 'package:flutter/material.dart';
import 'package:jhvostov_prac_1/features/care_tips/screens/care_tips_screen.dart';
import 'package:jhvostov_prac_1/features/fertilizers/screens/fertilizer_screen.dart';
import 'package:jhvostov_prac_1/features/my_plants/screens/my_plants_screen.dart';
import 'package:jhvostov_prac_1/features/plant/state/plants_container.dart';
import 'package:jhvostov_prac_1/features/watering/screens/watering_screen.dart';
import 'package:jhvostov_prac_1/shared/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Добавьте этот импорт

void main() {
  runApp(PlantApp());
}

class PlantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Мой Сад',
      theme: AppTheme.lightTheme,
      home: GardenScreen(),
    );
  }
}

class GardenScreen extends StatelessWidget {
  final String _imageUrl = "https://ir.ozone.ru/s3/multimedia-b/6606452423.jpg";

  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Мои растения',
      'icon': Icons.favorite,
      'screen': const PlantsContainer(),
    },
    {
      'title': 'Полив',
      'icon': Icons.water_drop,
      'screen': WateringScreen(),
    },
    {
      'title': 'Советы',
      'icon': Icons.water_drop,
      'screen': CareTipsScreen(),
    },
    {
      'title': 'Удобрения',
      'icon': Icons.agriculture,
      'screen': FertilizerScreen(),
    },
    {
      'title': 'Состояние растений',
      'icon': Icons.local_florist_rounded,
      'screen': MyPlantsScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Мой Сад')),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: menuItems.length + 2, // из-за изображение увеличиваем на 2
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
              item['screen'] as Widget,
            );
          }
        },
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon, Widget screen) {
    return Center(
      child: Container(
        width: 250,
        margin: EdgeInsets.all(8),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
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