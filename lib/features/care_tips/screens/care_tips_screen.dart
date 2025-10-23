import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CareTipsScreen extends StatefulWidget {
  @override
  _CareTipsScreenState createState() => _CareTipsScreenState();
}

class _CareTipsScreenState extends State<CareTipsScreen> {

  final String _imageUrl = "https://static.tildacdn.com/tild6438-6539-4066-a439-663263363239/free-icon-grow-plant.png";


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

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tipController = TextEditingController();

  void _addNewTip() {
    if (_titleController.text.isNotEmpty && _tipController.text.isNotEmpty) {
      setState(() {
        tips.add({
          'title': _titleController.text,
          'tip': _tipController.text,
        });
      });
      _titleController.clear();
      _tipController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Совет добавлен!')),
      );
    }
  }

  void _removeTip(int index) {
    setState(() {
      tips.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Совет удален!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Советы по уходу')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child:
            SizedBox(
              width: 210,
              height: 210,
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



            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Добавить новый совет',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Название совета',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 2.0),
                        ),
                        focusColor: Colors.green,
                        labelStyle: TextStyle(color: Colors.green),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _tipController,
                      decoration: InputDecoration(
                        labelText: 'Текст совета',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 2.0),
                        ),
                        focusColor: Colors.green,
                        labelStyle: TextStyle(color: Colors.green),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _addNewTip,
                        icon: Icon(Icons.add),
                        label: Text('Добавить совет'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text('Советы по уходу:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),

            for (int i = 0; i < tips.length; i++)
              GestureDetector(
                key: ValueKey('tip_${tips[i]['title']}_$i'),
                onTap: () => _removeTip(i),
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(tips[i]['title']!,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            Icon(Icons.delete_outline, color: Colors.red, size: 20),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(tips[i]['tip']!),
                        SizedBox(height: 5),
                        Text(
                          'Нажмите для удаления',
                          style: TextStyle(fontSize: 10, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _tipController.dispose();
    super.dispose();
  }
}