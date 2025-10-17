import 'package:flutter/material.dart';

class FertilizerScreen extends StatefulWidget {
  @override
  _FertilizerScreenState createState() => _FertilizerScreenState();
}

class _FertilizerScreenState extends State<FertilizerScreen> {
  final List<String> fertilizers = [
    'Органические удобрения',
    'Минеральные удобрения',
    'Комплексные удобрения',
    'Специальные смеси для цветов',
    'Удобрения для кактусов'
  ];

  final TextEditingController _fertilizerController = TextEditingController();

  void _addNewFertilizer() {
    if (_fertilizerController.text.isNotEmpty) {
      setState(() {
        fertilizers.add(_fertilizerController.text);
      });
      _fertilizerController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Удобрение добавлено!')),
      );
    }
  }

  void _removeFertilizer(int index) {
    setState(() {
      fertilizers.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Удобрение удалено!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Удобрения')),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Добавить удобрение',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  TextField(
                    controller: _fertilizerController,
                    decoration: InputDecoration(
                      labelText: 'Название удобрения',
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
                    onPressed: _addNewFertilizer,
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
            child: Text('Рекомендуемые удобрения:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView(
              children: [
                for (int i = 0; i < fertilizers.length; i++)
                  GestureDetector(
                    key: ValueKey('fertilizer_${fertilizers[i]}_$i'),
                    onTap: () => _removeFertilizer(i),
                    child: ListTile(
                      leading: Icon(Icons.agriculture, color: Colors.brown),
                      title: Text(fertilizers[i]),
                      trailing: Icon(Icons.delete_outline, color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fertilizerController.dispose();
    super.dispose();
  }
}