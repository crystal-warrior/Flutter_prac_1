import 'package:flutter/material.dart';

class CareTipsScreen extends StatelessWidget {
  final List<Map<String, String>> tips = [
    {'title': 'Полив', 'tip': 'Поливайте утром или вечером'},
    {'title': 'Свет', 'tip': 'Обеспечьте достаточно солнечного света'},
    {'title': 'Температура', 'tip': 'Избегайте резких перепадов температуры'},
    {'title': 'Почва', 'tip': 'Используйте качественную почвенную смесь'},
    {'title': 'Обрезка', 'tip': 'Регулярно обрезайте сухие листья'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Советы по уходу')),
      body: ListView.builder(
        itemCount: tips.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tips[index]['title']!,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(tips[index]['tip']!),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}