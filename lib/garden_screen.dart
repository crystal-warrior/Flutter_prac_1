import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GardenScreen extends StatefulWidget {
  const GardenScreen({super.key});

  @override
  _GardenScreenState createState() => _GardenScreenState();
}

class _GardenScreenState extends State<GardenScreen> {
  final List<Map<String, dynamic>> _screens = [
    {
      'title': 'Мои растения',
      'icon': Icons.favorite,
      'route': '/garden/my_plants',
      'color': Colors.lightGreen,
    },
    {
      'title': 'Полив',
      'icon': Icons.water_drop,
      'route': '/garden/watering',
      'color': Colors.lightGreen,
    },
    {
      'title': 'Удобрения',
      'icon': Icons.agriculture,
      'route': '/garden/fertilizers',
      'color': Colors.lightGreen,
    },
    {
      'title': 'Советы по уходу',
      'icon': Icons.lightbulb,
      'route': '/garden/care_tips',
      'color': Colors.lightGreen,
    },
    {
      'title': 'Состояние растений',
      'icon': Icons.eco,
      'route': '/garden/plant_status',
      'color': Colors.lightGreen,
    },
  ];

  void _navigateToScreen(String route, String title) {
    context.push(route);
  }

  void _logout() {
    context.go('/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главный экран'),
        backgroundColor: Colors.lightGreen,
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
                itemCount: _screens.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final screen = _screens[index];
                  return ElevatedButton(
                    onPressed: () => _navigateToScreen(screen['route'], screen['title']),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: screen['color'],
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(screen['icon'], color: Colors.white, size: 28),
                        const SizedBox(width: 16),
                        Text(
                          screen['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: _logout,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: const BorderSide(color: Colors.red),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    'Выйти из приложения',
                    style: TextStyle(
                      fontSize: 16,
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