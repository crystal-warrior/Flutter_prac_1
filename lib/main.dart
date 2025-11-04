import 'package:flutter/material.dart';
import 'autorization.dart';
import 'shared/app_theme.dart';

void main() {
  runApp(PlantApp());
}

class PlantApp extends StatelessWidget {
  PlantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Мой Сад',
      theme: AppTheme.lightTheme,
      home: const AuthorizationScreen(),
    );
  }
}