import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jhvostov_prac_1/features/authorization/cubit/auth_cubit.dart';
import 'package:jhvostov_prac_1/models/user.dart';

class AuthorizationScreen extends StatelessWidget {
  const AuthorizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _loginController = TextEditingController();
    final _passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Авторизация'),
        backgroundColor: Colors.lightGreen,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Мы Вас ждали!', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),

            /*
            TextField(
              controller: _loginController,
              decoration: const InputDecoration(
                labelText: 'Логин',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

             */
            TextField(
              controller: _loginController,
              style: const TextStyle(color: Colors.lightGreen),
              decoration: InputDecoration(
                labelText: 'Логин',
                labelStyle: const TextStyle(color: Colors.lightGreen),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.lightGreen),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.lightGreen),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.lightGreen, width: 2.0),
                ),
                floatingLabelStyle: const TextStyle(color: Colors.lightGreen),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _passwordController,
              style: const TextStyle(color: Colors.lightGreen),
              decoration: InputDecoration(
                labelText: 'Пароль',
                labelStyle: const TextStyle(color: Colors.lightGreen),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.lightGreen),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.lightGreen),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.lightGreen, width: 2.0),
                ),
                floatingLabelStyle: const TextStyle(color: Colors.lightGreen),
              ),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                final login = _loginController.text.trim();
                final password = _passwordController.text.trim();

                if (login.isEmpty) {
                  _showError(context, 'Введите логин');
                  return;
                }
                if (password.isEmpty) {
                  _showError(context, 'Введите пароль');
                  return;
                }

                final user = User(login: login, password: password);
                context.read<AuthCubit>().setUser(user);
                context.go('/garden');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.white,
              ),
              child: const Text('Войти'),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => context.go('/register'),
              child: const Text(
                'Нет аккаунта? Зарегистрируйтесь',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}