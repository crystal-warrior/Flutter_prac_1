import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jhvostov_prac_1/features/authorization/cubit/auth_cubit.dart';

class AuthorizationScreen extends StatelessWidget {
  const AuthorizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _loginController = TextEditingController();
    final _passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Авторизация'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              decoration: InputDecoration(
                labelText: 'Логин',
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0),
                ),
                floatingLabelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _passwordController,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              decoration: InputDecoration(
                labelText: 'Пароль',
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0),
                ),
                floatingLabelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {
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

                final authCubit = context.read<AuthCubit>();
                await authCubit.authenticate(login, password);
                
                if (!context.mounted) return;
                
                if (authCubit.state.isAuthenticated) {
                  context.go('/garden');
                } else {
                  _showError(context, authCubit.state.error ?? 'Ошибка авторизации');
                }
              },
              style: ElevatedButton.styleFrom(),
              child: const Text('Войти'),
            ),
            const SizedBox(height: 30),
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
            const SizedBox(height: 20),
          ],
        ),
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