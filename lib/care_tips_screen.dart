import 'package:flutter/material.dart';

class CareTipsScreen extends StatelessWidget {
  final List<Map<String, String>> tips = [
    {'title': 'Полив', 'tip': 'Поливайте утром или вечером'},
    {'title': 'Свет', 'tip': 'Обеспечьте достаточно солнечного света'},
    {'title': 'Температура', 'tip': 'Избегайте резких перепадов температуры'},
    {'title': 'Почва', 'tip': 'Используйте качественную почвенную смесь'},
    {'title': 'Обрезка', 'tip': 'Регулярно обрезайте сухие листья'},
    {'title': 'Подкормка', 'tip': 'Удобряйте растения в период активного роста'},
    {'title': 'Влажность', 'tip': 'Опрыскивайте листья тропических растений'},
    {'title': 'Дренаж', 'tip': 'Используйте дренаж на дне горшка для отвода лишней воды'},
    {'title': 'Пересадка', 'tip': 'Пересаживайте растения весной в горшок на 2-3 см больше'},
    {'title': 'Вредители', 'tip': 'Регулярно осматривайте растения на наличие вредителей'},
    {'title': 'Проветривание', 'tip': 'Обеспечьте циркуляцию воздуха вокруг растений'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Советы по уходу')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < tips.length; i++)
              Card(
                margin: EdgeInsets.only(bottom: 15),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tips[i]['title']!,
                          style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(tips[i]['tip']!),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  }