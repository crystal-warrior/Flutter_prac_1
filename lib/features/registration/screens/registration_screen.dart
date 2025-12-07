import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jhvostov_prac_1/features/authorization/cubit/auth_cubit.dart';
import 'package:jhvostov_prac_1/core/models/user.dart';
import 'package:jhvostov_prac_1/domain/usecases/get_location_usecase.dart';
import 'package:jhvostov_prac_1/di/service_locator.dart';

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
  String? _detectedCity;
  String? _detectedAddress;

  List<String> _regions = [
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
    'Московская область',
    'Ленинградская область',
    'Новосибирская область',
    'Свердловская область',
    'Республика Татарстан',
    'Нижегородская область',
    'Челябинская область',
    'Самарская область',
    'Омская область',
    'Ростовская область',
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/auth'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            const Text('Введите всю информацию, чтобы пользоваться функциями нашего приложения!', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),

            // Логин
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

            // Пароль
            TextField(
              controller: _passwordController,
              obscureText: true,
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
            const SizedBox(height: 16),

            // Телефон
            TextField(
              controller: _phoneController,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              decoration: InputDecoration(
                labelText: 'Телефон (или email)',
                hintText: '+7 (999) 123-45-67',
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                hintStyle: const TextStyle(color: Colors.grey),
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

            // Email
            TextField(
              controller: _emailController,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
              decoration: InputDecoration(
                labelText: 'Email (или телефон)',
                hintText: 'user@example.com',
                labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                hintStyle: const TextStyle(color: Colors.grey),
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

            // Регион
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedRegion,
                    icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.primary),
                    decoration: InputDecoration(
                      labelText: 'Регион проживания',
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
                    hint: Text('Выберите регион', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                    items: _regions.map((region) {
                      return DropdownMenuItem(
                        value: region,
                        child: Text(region, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRegion = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.my_location, color: Theme.of(context).colorScheme.primary),
                  onPressed: () async {
                    try {
                      final getLocationUseCase = locator<GetLocationUseCase>();
                      final location = await getLocationUseCase();
                      setState(() {
                        if (location.region != null) {
                          // Проверяем, есть ли регион в списке
                          if (!_regions.contains(location.region)) {
                            // Если региона нет в списке, добавляем его
                            _regions.add(location.region!);
                          }
                          _selectedRegion = location.region;
                        } else if (location.city != null) {
                          // Если региона нет, но есть город, попробуем найти в списке
                          final foundRegion = _regions.firstWhere(
                            (r) => r.contains(location.city!) || location.city!.contains(r),
                            orElse: () {
                              // Если не нашли, добавляем город в список
                              _regions.add(location.city!);
                              return location.city!;
                            },
                          );
                          _selectedRegion = foundRegion;
                        }
                        _detectedCity = location.city;
                        _detectedAddress = location.address;
                        
                        // Отладочный вывод
                        print('Определено местоположение:');
                        print('  Регион: ${location.region}');
                        print('  Город: ${location.city}');
                        print('  Адрес: ${location.address}');
                        print('  _detectedCity: $_detectedCity');
                        print('  _detectedAddress: $_detectedAddress');
                      });
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              location.region != null
                                  ? 'Местоположение определено: ${location.region}'
                                  : location.city != null
                                      ? 'Город определен: ${location.city}'
                                      : 'Местоположение определено',
                            ),
                            backgroundColor: Theme.of(context).colorScheme.primary,
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Ошибка определения местоположения: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  tooltip: 'Определить местоположение автоматически',
                ),
              ],
            ),
            // Поля для отображения определенного адреса и города
            if (_detectedAddress != null || _detectedCity != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_detectedCity != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                'Город: $_detectedCity',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          if (_detectedAddress != null)
                            Text(
                              'Адрес: $_detectedAddress',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 30),


            ElevatedButton(
              onPressed: () async {
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
                  city: _detectedCity,
                  address: _detectedAddress,
                );

                // Отладочный вывод
                print('Регистрация пользователя:');
                print('  Логин: ${user.login}');
                print('  Регион: ${user.region}');
                print('  Город: ${user.city}');
                print('  Адрес: ${user.address}');

                final authCubit = context.read<AuthCubit>();
                await authCubit.register(user);
                
                if (!context.mounted) return;
                
                if (authCubit.state.isAuthenticated) {
                  context.go('/garden');
                } else {
                  _showError(authCubit.state.error ?? 'Ошибка регистрации');
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Зарегистрироваться', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
          ],
        ),
        ),
      ),
    );
  }
}