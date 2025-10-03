import 'package:flutter/material.dart';

class WateringScreen extends StatefulWidget {
  @override
  _WateringScreenState createState() => _WateringScreenState();
}

class _WateringScreenState extends State<WateringScreen> {
  int _waterLevel = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Полив растений')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.water_drop, size: 60, color: Colors.blue),
            SizedBox(height: 20),
            Text('Уровень полива: $_waterLevel%',
                style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Slider(
              value: _waterLevel.toDouble(),
              min: 0,
              max: 100,
              activeColor: Colors.blue,
              onChanged: (value) {
                setState(() {
                  _waterLevel = value.round();
                });
              },
            ),
            SizedBox(height: 20),
            Text('Регулируйте уровень полива растений'),
          ],
        ),
      ),
    );
  }
}