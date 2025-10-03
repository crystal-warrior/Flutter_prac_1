import 'package:flutter/material.dart';

class PlantCatalogScreen extends StatelessWidget {
  final List<Map<String, String>> plants = [
    {'name': 'Кактус', 'care': 'Мало воды, много солнца'},
    {'name': 'Фикус', 'care': 'Умеренный полив'},
    {'name': 'Роза', 'care': 'Много солнца, регулярный полив'},
    {'name': 'Орхидея', 'care': 'Влажность, рассеянный свет'},
    {'name': 'Фиалка', 'care': 'Мало воды, солнце'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Каталог растений')),
      body: ListView.builder(
        itemCount: plants.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: Icon(Icons.eco, color: Colors.green),
              title: Text(plants[index]['name']!),
              subtitle: Text(plants[index]['care']!),
              trailing: Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    );
  }
}