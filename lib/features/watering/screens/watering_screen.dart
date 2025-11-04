import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WateringScreen extends StatefulWidget {
  @override
  _WateringScreenState createState() => _WateringScreenState();
}

class _WateringScreenState extends State<WateringScreen> {
  int _waterLevel = 0;

  final String _imageUrl = "https://cdn-icons-png.flaticon.com/512/4195/4195647.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox( // размеры изображения
              width: 100,
              height: 100,
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
            SizedBox(height: 20),
            Text('Уровень полива: $_waterLevel%',
                style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Slider(
              value: _waterLevel.toDouble(),
              min: 0,
              max: 100,
              activeColor: Colors.blue,
              inactiveColor: Colors.blue.withOpacity(0.3),
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