
import 'package:flutter/material.dart';
import 'app_router.dart';
import 'state/app_state.dart';
import 'di/service_locator.dart';

void main() {
  setupLocator();
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
    locator.get<UserService>().setLogin(login);
    setState(() {
      _login = login;
    });
  }

  void clearLogin() {
    locator.get<UserService>().clearLogin();
    setState(() {
      _login = null;
    });
  }

  @override
  void initState() {
    super.initState();
    initRouter(setLogin, clearLogin);
  }

  @override
  Widget build(BuildContext context) {
    return AppState(
      login: _login,
      child: MaterialApp.router(
        title: 'Мой Сад',
        theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)),
        routerConfig: appRouter,
      ),
    );
  }
}