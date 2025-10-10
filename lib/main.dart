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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Мой Сад')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text('Тестовый текст 1!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Тестовый текст 2!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Тестовый текст 3!',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            SizedBox(height: 40),
            _buildMenuButton(context, 'Каталог растений', Icons.spa, PlantCatalogScreen()),
            _buildMenuButton(context, 'Полив', Icons.water_drop, WateringScreen()),
            _buildMenuButton(context, 'Удобрения', Icons.eco, FertilizerScreen()),
            _buildMenuButton(context, 'Советы по уходу', Icons.help, CareTipsScreen()),
            _buildMenuButton(context, 'Мои растения', Icons.agriculture, MyPlantsScreen()),
            _buildMenuButton(context, 'Кнопка в разработке', Icons.access_alarm_outlined, MyPlantsScreen()),
            _buildMenuButton(context, 'Эксперимент', Icons.account_balance, MyPlantsScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon, Widget screen) {
    return Container(
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
    );
  }

}
