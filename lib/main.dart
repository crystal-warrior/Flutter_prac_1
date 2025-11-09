import 'package:flutter/material.dart';
import 'app_router.dart';
import 'state/app_state.dart';
import 'app_router.dart' as router;

void main() {
  runApp(const PlantApp());
}

class PlantApp extends StatefulWidget {
  const PlantApp({super.key});

  @override
  State<PlantApp> createState() => _PlantAppState();
}

class _PlantAppState extends State<PlantApp> {
  String? _login;

  void setLogin(String login) {
    setState(() {
      _login = login;
    });
  }

  void clearLogin() {
    setState(() {
      _login = null;
    });
  }

  @override
  void initState() {
    router.initRouter(setLogin, clearLogin);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppState(
      login: _login,
      child: MaterialApp.router(
        routerConfig: router.appRouter,
        title: 'Мой Сад',
        theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
      ),
    );
  }
}