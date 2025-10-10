import 'package:flutter/material.dart';
import 'package:jhvostov_prac_1/care_tips_screen.dart';
import 'package:jhvostov_prac_1/fertilizer_screen.dart';
import 'package:jhvostov_prac_1/my_plants_screen.dart';
import 'package:jhvostov_prac_1/plant_catalog_screen.dart';
import 'package:jhvostov_prac_1/watering_screen.dart';

void main() {
  runApp(PlantApp());
}

class PlantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Мой Сад',
      theme: ThemeData(primarySwatch: Colors.green),
      home: GardenScreen(),
    );
  }
}

class GardenScreen extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Каталог растений',
      'icon': Icons.spa,
      'screen': PlantCatalogScreen(),
    },
    {
      'title': 'Полив',
      'icon': Icons.water_drop,
      'screen': WateringScreen(),
    },
    {
      'title': 'Удобрения',
      'icon': Icons.eco,
      'screen': FertilizerScreen(),
    },
    {
      'title': 'Советы по уходу',
      'icon': Icons.help,
      'screen': CareTipsScreen(),
    },
    {
      'title': 'Мои растения',
      'icon': Icons.agriculture,
      'screen': MyPlantsScreen(),
    },
    {
      'title': 'Кнопка в разработке',
      'icon': Icons.access_alarm_outlined,
      'screen': MyPlantsScreen(),
    },
    {
      'title': 'Эксперимент',
      'icon': Icons.account_balance,
      'screen': MyPlantsScreen(),
    },
    {
      'title': 'Дополнительная кнопка 1',
      'icon': Icons.add,
      'screen': MyPlantsScreen(),
    },
    {
      'title': 'Дополнительная кнопка 2',
      'icon': Icons.grass,
      'screen': MyPlantsScreen(),
    },
    {
      'title': 'Дополнительная кнопка 3',
      'icon': Icons.local_florist,
      'screen': MyPlantsScreen(),
    },
    {
      'title': 'Дополнительная кнопка 4',
      'icon': Icons.park,
      'screen': MyPlantsScreen(),
    },
    {
      'title': 'Дополнительная кнопка 5',
      'icon': Icons.nature,
      'screen': MyPlantsScreen(),
    },
    {
      'title': 'Дополнительная кнопка 6',
      'icon': Icons.forest,
      'screen': MyPlantsScreen(),
    },
    {
      'title': 'Дополнительная кнопка 7',
      'icon': Icons.emoji_nature,
      'screen': MyPlantsScreen(),
    },
    {
      'title': 'Дополнительная кнопка 8',
      'icon': Icons.yard,
      'screen': MyPlantsScreen(),
    },
    {
      'title': 'Дополнительная кнопка 9',
      'icon': Icons.eco,
      'screen': MyPlantsScreen(),
    },
    {
      'title': 'Дополнительная кнопка 10',
      'icon': Icons.spoke_rounded,
      'screen': MyPlantsScreen(),
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
                'Добро пожаловать в сад!',
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
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ),
    );
  }
}