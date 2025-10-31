import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyPlantsScreen extends StatefulWidget {
  @override
  _MyPlantsScreenState createState() => _MyPlantsScreenState();
}

class _MyPlantsScreenState extends State<MyPlantsScreen> {

  final String _imageUrl = "https://avatars.mds.yandex.net/i?id=d610e22a7fdf20c4ca2ea6b37f3340e8e89ba46b-4966461-images-thumbs&n=13";

  final List<Map<String, dynamic>> myPlants = [
    {'name': 'Кактус', 'days': 7, 'health': 'Хорошо'},
    {'name': 'Фикус', 'days': 3, 'health': 'Отлично'},
    {'name': 'Роза', 'days': 1, 'health': 'Нужен полив'},
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _healthController = TextEditingController();

  void _addNewPlant() {
    if (_nameController.text.isNotEmpty && _daysController.text.isNotEmpty && _healthController.text.isNotEmpty) {
      setState(() {
        myPlants.add({
          'name': _nameController.text,
          'days': int.tryParse(_daysController.text) ?? 0,
          'health': _healthController.text,
        });
      });
      _nameController.clear();
      _daysController.clear();
      _healthController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Растение добавлено!')),
      );
    }
  }

  void _removePlant(int index) {
    setState(() {
      myPlants.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Растение удалено!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Мои растения')),
      body: Column(
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
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Добавить растение',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Название растения',
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
                    controller: _daysController,
                    decoration: InputDecoration(
                      labelText: 'Дней до полива',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                      ),
                      focusColor: Colors.green,
                      labelStyle: TextStyle(color: Colors.green),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _healthController,
                    decoration: InputDecoration(
                      labelText: 'Состояние растения',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                      ),
                      focusColor: Colors.green,
                      labelStyle: TextStyle(color: Colors.green),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _addNewPlant,
                    icon: Icon(Icons.add),
                    label: Text('Добавить'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                return GestureDetector(
                  key: ValueKey('myplant_${myPlants[index]['name']}_$index'),
                  onTap: () => _removePlant(index),
                  child: Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      leading: Icon(Icons.eco, color: Colors.green),
                      title: Text(myPlants[index]['name']),
                      subtitle: Text('Полив через: ${myPlants[index]['days']} дней'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Chip(
                            label: Text(myPlants[index]['health']),
                            backgroundColor: myPlants[index]['health'] == 'Отлично'
                                ? Colors.green
                                : myPlants[index]['health'] == 'Нужен полив'
                                ? Colors.orange
                                : Colors.blue,
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.delete_outline, color: Colors.red),
                        ],
                      ),
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

  @override
  void dispose() {
    _nameController.dispose();
    _daysController.dispose();
    _healthController.dispose();
    super.dispose();
  }
}