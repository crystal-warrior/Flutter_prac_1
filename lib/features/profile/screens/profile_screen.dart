import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jhvostov_prac_1/features/authorization/cubit/auth_cubit.dart';
import 'package:jhvostov_prac_1/features/theme/cubit/theme_cubit.dart';
import 'package:jhvostov_prac_1/domain/usecases/get_location_usecase.dart';
import 'package:jhvostov_prac_1/domain/repositories/auth_repository.dart';
import 'package:jhvostov_prac_1/core/models/location.dart';
import 'package:jhvostov_prac_1/di/service_locator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _gardenAddressController = TextEditingController();
  String? _gardenAddress;
  bool _isSearchingGardenAddress = false;
  bool _isLoadingSavedPlaces = false;
  List<Location>? _savedPlacesAddresses;

  @override
  void dispose() {
    _gardenAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мой профиль'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/garden'),
        ),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final user = state.user;
          
          // Отладочный вывод
          if (user != null) {
            print('Профиль пользователя:');
            print('  Логин: ${user.login}');
            print('  Регион: ${user.region}');
            print('  Город: ${user.city}');
            print('  Адрес: ${user.address}');
          }
          
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.person_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Вы не авторизованы',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Center(
                  child: Text(
                    'Ваш профиль',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Здесь отображается информация, указанная при регистрации. Эти данные используются для персонализации ухода за вашими растениями. В частности, на основе вашего региона автоматически подбираются рекомендации по выбору и уходу за растениями, адаптированные к местному климату и сезону.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),

                // === Основная информация ===
                _buildSectionHeader(context, 'Основная информация'),
                _buildInfoRow(context, 'Логин', user.login),

                const SizedBox(height: 20),

                // === Контактные данные ===
                _buildSectionHeader(context, 'Контактные данные'),
                if (user.phone != null)
                  _buildInfoRow(context, 'Телефон', user.phone!),
                if (user.email != null)
                  _buildInfoRow(context, 'Электронная почта', user.email!),
                if (user.phone == null && user.email == null)
                  Text(
                    'Контактные данные не указаны',
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),

                const SizedBox(height: 20),

                // === Местоположение ===
                _buildSectionHeader(context, 'Местоположение'),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (user.region != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _buildInfoRow(context, 'Регион проживания', user.region!),
                            ),
                          if (user.city != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _buildInfoRow(context, 'Город', user.city!),
                            ),
                          if (user.address != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _buildInfoRow(context, 'Адрес', user.address!),
                            ),
                          if (user.region == null && user.city == null && user.address == null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Местоположение не указано',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.my_location, color: Theme.of(context).colorScheme.primary),
                      onPressed: () async {
                        try {
                          final getLocationUseCase = locator<GetLocationUseCase>();
                          final location = await getLocationUseCase();
                          final newRegion = location.region ?? location.city;
                          final updatedUser = user.copyWith(
                            region: newRegion,
                            city: location.city,
                            address: location.address,
                          );
                          context.read<AuthCubit>().setUser(updatedUser);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  location.address != null
                                      ? 'Местоположение обновлено: ${location.address}'
                                      : location.city != null
                                          ? 'Город обновлен: ${location.city}'
                                          : 'Местоположение обновлено',
                                ),
                                backgroundColor: Theme.of(context).colorScheme.primary,
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Ошибка определения местоположения: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      tooltip: 'Обновить местоположение по геолокации',
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // === Адрес садового участка ===
                _buildSectionHeader(context, 'Адрес садового участка'),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Адрес садового участка/дачи (необязательно)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Укажите адрес вашего садового участка или дачи для получения точных рекомендаций по уходу',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _gardenAddressController,
                                decoration: InputDecoration(
                                  hintText: 'Например: Московская область, д. Садовое, ул. Дачная, 15',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _gardenAddress = value.trim().isEmpty ? null : value.trim();
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            _isSearchingGardenAddress
                                ? const CircularProgressIndicator()
                                : IconButton(
                                    icon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                                    onPressed: () async {
                                      final address = _gardenAddressController.text.trim();
                                      if (address.isNotEmpty) {
                                        setState(() {
                                          _isSearchingGardenAddress = true;
                                        });
                                        try {
                                          final location = await locator<GetLocationUseCase>().getByAddress(address);
                                          setState(() {
                                            _gardenAddress = location.address;
                                          });
                                          
                                          // Обновляем местоположение пользователя
                                          final currentUser = context.read<AuthCubit>().state.user;
                                          if (currentUser != null) {
                                            final newRegion = location.region ?? location.city;
                                            final updatedUser = currentUser.copyWith(
                                              region: newRegion,
                                              city: location.city,
                                              address: location.address,
                                            );
                                            
                                            // Сохраняем обновленные данные через репозиторий
                                            final authRepository = locator<AuthRepository>();
                                            await authRepository.updateUser(updatedUser);
                                            
                                            // Обновляем состояние в Cubit
                                            context.read<AuthCubit>().setUser(updatedUser);
                                          }
                                          
                                          if (mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Адрес садового участка найден и местоположение обновлено: ${location.address ?? "Неизвестно"}'),
                                                backgroundColor: Theme.of(context).colorScheme.primary,
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Ошибка поиска адреса: $e'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        } finally {
                                          setState(() {
                                            _isSearchingGardenAddress = false;
                                          });
                                        }
                                      }
                                    },
                                    tooltip: 'Найти адрес садового участка',
                                  ),
                          ],
                        ),
                        if (_gardenAddress != null && _gardenAddress!.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _gardenAddress!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // === Получение адресов по координатам (метод 5: getAddressesByCoordinates) ===
                _buildSectionHeader(context, 'Сохраненные места'),
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Получение адресов для сохраненных координат',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Полезно для получения адресов нескольких сохраненных мест (дом, работа, дача) по их координатам',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _isLoadingSavedPlaces
                              ? null
                              : () async {
                                  setState(() {
                                    _isLoadingSavedPlaces = true;
                                  });
                                  try {
                                    // Пример координат для демонстрации (можно заменить на реальные сохраненные координаты)
                                    final coordinates = [
                                      {'lat': 55.7558, 'lon': 37.6173}, // Москва
                                      {'lat': 59.9343, 'lon': 30.3351}, // Санкт-Петербург
                                      {'lat': 55.8304, 'lon': 49.0661}, // Казань
                                    ];
                                    final locations = await locator<GetLocationUseCase>().getByCoordinates(coordinates);
                                    setState(() {
                                      _savedPlacesAddresses = locations;
                                    });
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Получено адресов: ${locations.length}'),
                                          backgroundColor: Theme.of(context).colorScheme.primary,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Ошибка получения адресов: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  } finally {
                                    setState(() {
                                      _isLoadingSavedPlaces = false;
                                    });
                                  }
                                },
                          icon: _isLoadingSavedPlaces
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.location_searching),
                          label: Text(_isLoadingSavedPlaces ? 'Загрузка...' : 'Получить адреса сохраненных мест'),
                        ),
                        if (_savedPlacesAddresses != null && _savedPlacesAddresses!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          ..._savedPlacesAddresses!.map((location) => Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (location.city != null)
                                        Text(
                                          location.city!,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      if (location.address != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          location.address!,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 4),
                                      Text(
                                        'Координаты: ${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // === Настройки ===
                _buildSectionHeader(context, 'Настройки'),
                BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, themeState) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: SwitchListTile(
                        title: Row(
                          children: [
                            Icon(
                              themeState.themeMode == AppThemeMode.nightGarden
                                  ? Icons.nightlight_round
                                  : Icons.wb_sunny,
                              color: themeState.themeMode == AppThemeMode.nightGarden
                                  ? const Color(0xFF9BB5FF)
                                  : Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              themeState.themeMode == AppThemeMode.nightGarden
                                  ? 'Ночной сад'
                                  : 'Дневной сад',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          themeState.themeMode == AppThemeMode.nightGarden
                              ? 'Темная тема с фиолетовыми и голубыми оттенками'
                              : 'Светлая тема с зелеными оттенками',
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        value: themeState.themeMode == AppThemeMode.nightGarden,
                        onChanged: (value) {
                          context.read<ThemeCubit>().toggleTheme();
                        },
                        activeColor: const Color(0xFF6C5CE7),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<AuthCubit>().logout();
                        context.go('/auth');
                      },
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text(
                        'Выйти из аккаунта',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}