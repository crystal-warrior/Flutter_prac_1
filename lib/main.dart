import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'shared/app_theme.dart';
import 'app_router.dart';

void main() {
  runApp(PlantApp());
}

class PlantApp extends StatelessWidget {
  PlantApp({super.key});

  final GoRouter _router = appRouter;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Мой Сад',
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}