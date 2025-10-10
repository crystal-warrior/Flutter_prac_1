import 'package:flutter/material.dart';

class PlantCatalogScreen extends StatefulWidget {
  @override
  _PlantCatalogScreenState createState() => _PlantCatalogScreenState();
}

class _PlantCatalogScreenState extends State<PlantCatalogScreen> {
  final List<Map<String, String>> plants = [
    {'name': 'Кактус', 'care': 'Мало воды, много солнца'},
    {'name': 'Фикус', 'care': 'Умеренный полив'},
    {'name': 'Роза', 'care': 'Много солнца, регулярный полив'},
    {'name': 'Орхидея', 'care': 'Влажность, рассеянный свет'},
    {'name': 'Фиалка', 'care': 'Мало воды, солнце'},
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _careController = TextEditingController();

  void _addNewPlant() {
    if (_nameController.text.isNotEmpty && _careController.text.isNotEmpty) {
      setState(() {
        plants.add({
          'name': _nameController.text,
          'care': _careController.text,
        });
      });
      _nameController.clear();
      _careController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Растение добавлено!')),
      );
    }
  }

  void _removePlant(int index) {
    setState(() {
      plants.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Растение удалено!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Каталог растений')),
      body: Column(
        children: [
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
                    controller: _careController,
                    decoration: InputDecoration(
                      labelText: 'Уход за растением',
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
          Expanded(
            child: ListView.builder(
              itemCount: plants.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  key: ValueKey('plant_${plants[index]['name']}_$index'),
                  onTap: () => _removePlant(index),
                  child: Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      leading: Icon(Icons.eco, color: Colors.green),
                      title: Text(plants[index]['name']!),
                      subtitle: Text(plants[index]['care']!),
                      trailing: Icon(Icons.delete_outline, color: Colors.red),
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
    _careController.dispose();
    super.dispose();
  }
}