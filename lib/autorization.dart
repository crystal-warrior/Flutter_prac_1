
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'di/service_locator.dart';

class AuthorizationScreen extends StatelessWidget {
  final Function(String) setLogin;

  const AuthorizationScreen({super.key, required this.setLogin});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Авторизация'), backgroundColor: Colors.lightGreen),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Введите ваш логин', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Логин',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                final login = _controller.text.trim();
                if (login.isNotEmpty) {

                  locator<UserService>().setLogin(login);

                  setLogin(login);

                  context.go('/garden');
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen),
              child: const Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }
}