import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../authorization/cubit/auth_cubit.dart';

class GardenScreen extends StatelessWidget {
  const GardenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: () => context.go('/profile'),
        ),
        title: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final login = state.user?.login ?? 'Гость';
            return Text('Привет, $login!');
          },
        ),
        actions: [

          /*
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthCubit>().logout();
              context.go('/auth');
            },
          ),

          */


        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Добро пожаловать в ваш сад!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Выберите раздел для управления вашими растениями',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            Expanded(
              child: ListView.separated(
                itemCount: 9, // Обновлено количество экранов
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final List<Map<String, Object>> screens = [
                    /*
                    {
                      'title': 'Мои растения',
                      'icon': Icons.favorite,
                      'route': '/garden/my_plants'
                    },

                     */
                    {
                      'title': 'Погода',
                      'icon': Icons.wb_sunny,
                      'route': '/garden/weather'
                    },
                    {
                      'title': 'Лунный календарь',
                      'icon': Icons.nightlight_round,
                      'route': '/garden/lunar_calendar'
                    },
                    {
                      'title': 'Регуляция полива',
                      'icon': Icons.water_drop,
                      'route': '/garden/watering'
                    },
                    {
                      'title': 'Удобрения',
                      'icon': Icons.agriculture,
                      'route': '/garden/fertilizers'
                    },
                    {
                      'title': 'Советы по уходу',
                      'icon': Icons.lightbulb,
                      'route': '/garden/care_tips'
                    },
                    {
                      'title': 'Растения на полив',
                      'icon': Icons.eco,
                      'route': '/garden/plant_status'
                    },
                    {
                      'title': 'Календарь посадок',
                      'icon': Icons.calendar_today,
                      'route': '/garden/planting_calendar'
                    },
                    {
                      'title': 'Рекомендуемые растения',
                      'icon': Icons.local_florist,
                      'route': '/garden/recommended_plants'
                    },
                    {
                      'title': 'Восход и закат',
                      'icon': Icons.wb_twilight,
                      'route': '/garden/sunrise_sunset'
                    },
                  ];

                  final screen = screens[index];
                  final String title = screen['title'] as String;
                  final IconData icon = screen['icon'] as IconData;
                  final String route = screen['route'] as String;

                  return ElevatedButton(
                    onPressed: () => context.push(route),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(icon, size: 28),
                        const SizedBox(width: 16),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

           /*
            OutlinedButton(
              onPressed: () {
                context.read<AuthCubit>().logout();
                context.go('/auth');
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    'Выйти из приложения',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            */
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

