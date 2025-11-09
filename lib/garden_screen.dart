import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'state/app_state.dart';

class GardenScreen extends StatelessWidget {
  final VoidCallback clearLogin;

  const GardenScreen({super.key, required this.clearLogin});

  void _logout(BuildContext context) {
    clearLogin();
    context.go('/auth');
  }

  @override
  Widget build(BuildContext context) {
    final login = AppState.of(context).login ?? 'Гость';

    return Scaffold(
      appBar: AppBar(
        title: Text('Привет, $login!'),
        backgroundColor: Colors.lightGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
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
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Выберите раздел для управления вашими растениями:',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            Expanded(
              child: ListView.separated(
                itemCount: 5,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {

                  final List<Map<String, Object>> screens = [
                    {
                      'title': 'Мои растения',
                      'icon': Icons.favorite,
                      'route': '/garden/my_plants'
                    },
                    {
                      'title': 'Полив',
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
                      'title': 'Состояние растений',
                      'icon': Icons.eco,
                      'route': '/garden/plant_status'
                    },
                  ];

                  final screen = screens[index];

                  // 🔸 Явно приводим типы
                  final String title = screen['title'] as String;
                  final IconData icon = screen['icon'] as IconData;
                  final String route = screen['route'] as String;

                  return ElevatedButton(
                    onPressed: () => context.push(route),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(icon, color: Colors.white, size: 28),
                        const SizedBox(width: 16),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => _logout(context),
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
                  SizedBox(width: 8),
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
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}