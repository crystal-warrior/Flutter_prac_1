import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jhvostov_prac_1/features/authorization/cubit/auth_cubit.dart';
import 'package:jhvostov_prac_1/models/user.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedRegion;

  final List<String> _regions = [
    'Москва',
    'Санкт-Петербург',
    'Новосибирск',
    'Екатеринбург',
    'Казань',
    'Нижний Новгород',
    'Челябинск',
    'Самара',
    'Омск',
    'Ростов-на-Дону',
  ];

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.lightGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/auth'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Введите всю информацию, чтобы пользоваться функциями нашего приложения!', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),

            // Логин
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

            // Пароль
            TextField(
              controller: _passwordController,
              obscureText: true,
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
            const SizedBox(height: 16),

            // Телефон
            TextField(
              controller: _phoneController,
              style: const TextStyle(color: Colors.lightGreen),
              decoration: InputDecoration(
                labelText: 'Телефон (или email)',
                hintText: '+7 (999) 123-45-67',
                labelStyle: const TextStyle(color: Colors.lightGreen),
                hintStyle: const TextStyle(color: Colors.grey),
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

            // Email
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.lightGreen),
              decoration: InputDecoration(
                labelText: 'Email (или телефон)',
                hintText: 'user@example.com',
                labelStyle: const TextStyle(color: Colors.lightGreen),
                hintStyle: const TextStyle(color: Colors.grey),
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

            // Регион
            DropdownButtonFormField<String>(
              value: _selectedRegion,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.lightGreen),
              decoration: InputDecoration(
                labelText: 'Регион проживания',
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
              hint: const Text('Выберите регион', style: TextStyle(color: Colors.lightGreen)),
              items: _regions.map((region) {
                return DropdownMenuItem(
                  value: region,
                  child: Text(region, style: const TextStyle(color: Colors.lightGreen)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRegion = value;
                });
              },
            ),

            const SizedBox(height: 30),


            ElevatedButton(
              onPressed: () {
                final login = _loginController.text.trim();
                final password = _passwordController.text.trim();
                final phone = _phoneController.text.trim();
                final email = _emailController.text.trim();
                final region = _selectedRegion;

                if (login.isEmpty) {
                  _showError('Логин обязателен');
                  return;
                }
                if (password.isEmpty) {
                  _showError('Пароль обязателен');
                  return;
                }
                if (phone.isEmpty && email.isEmpty) {
                  _showError('Укажите телефон или email');
                  return;
                }
                if (region == null) {
                  _showError('Выберите регион');
                  return;
                }

                final user = User(
                  login: login,
                  password: password,
                  phone: phone.isEmpty ? null : phone,
                  email: email.isEmpty ? null : email,
                  region: region,
                );

                context.read<AuthCubit>().setUser(user);
                context.go('/garden');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Зарегистрироваться', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}