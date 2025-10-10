import 'package:flutter/material.dart';

class FertilizerScreen extends StatelessWidget {
  final List<String> fertilizers = [
    'Органические удобрения',
    'Минеральные удобрения',
    'Комплексные удобрения',
    'Специальные смеси для цветов',
    'Удобрения для кактусов'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Удобрения')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('Рекомендуемые удобрения:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView(
              children: fertilizers.map((fertilizer) {
                return ListTile(
                  leading: Icon(Icons.agriculture, color: Colors.brown),
                  title: Text(fertilizer),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}