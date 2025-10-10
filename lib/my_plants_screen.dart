import 'package:flutter/material.dart';

class MyPlantsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> myPlants = [
    {'name': 'Кактус', 'days': 7, 'health': 'Хорошо'},
    {'name': 'Фикус', 'days': 3, 'health': 'Отлично'},
    {'name': 'Роза', 'days': 1, 'health': 'Нужен полив'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Мои растения')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('Ваши растения:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: myPlants.length,
              separatorBuilder: (context, index) => Divider(
                height: 20,
                color: Colors.green[300],
              ),
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: Icon(Icons.eco, color: Colors.green),
                    title: Text(myPlants[index]['name']),
                    subtitle: Text('Полив через: ${myPlants[index]['days']} дней'),
                    trailing: Chip(
                      label: Text(myPlants[index]['health']),
                      backgroundColor: myPlants[index]['health'] == 'Отлично'
                          ? Colors.green
                          : myPlants[index]['health'] == 'Нужен полив'
                          ? Colors.orange
                          : Colors.blue,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}