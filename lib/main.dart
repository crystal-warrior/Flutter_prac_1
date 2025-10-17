import 'package:flutter/material.dart';
import 'package:jhvostov_prac_1/features/care_tips/screens/care_tips_screen.dart';
import 'package:jhvostov_prac_1/features/fertilizers/screens/fertilizer_screen.dart';
import 'package:jhvostov_prac_1/features/my_plants/screens/my_plants_screen.dart';
import 'package:jhvostov_prac_1/features/plant/state/plants_container.dart';
import 'package:jhvostov_prac_1/features/watering/screens/watering_screen.dart';
import 'package:jhvostov_prac_1/shared/app_theme.dart';

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
  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Полив',
      'icon': Icons.water_drop,
      'screen': WateringScreen(),
    },
    {
      'title': 'Удобрения',
      'icon': Icons.agriculture,
      'screen': FertilizerScreen(),
    },
    {
      'title': 'Советы по уходу',
      'icon': Icons.help,
      'screen': CareTipsScreen(),
    },
    {
      'title': 'Состояние растений',
      'icon': Icons.eco,
      'screen': MyPlantsScreen(),
    },
    {
      'title': 'Мои растения',
      'icon': Icons.favorite,
      'screen': const PlantsContainer(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Мой Сад')),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: menuItems.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Align(
              alignment: Alignment.center,
              child: Text(
                'Добро пожаловать в Сад!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            final menuIndex = index - 1;
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