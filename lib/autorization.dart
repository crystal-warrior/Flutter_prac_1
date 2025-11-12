
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jhvostov_prac_1/auth/cubit/auth_cubit.dart';
import 'di/service_locator.dart';

class AuthorizationScreen extends StatelessWidget {
  const AuthorizationScreen({super.key});

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

                 // locator<UserService>().setLogin(login);


                  context.read<AuthCubit>().setLogin(login);


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